# frozen_string_literal: true

module Api
  module V1
    class VacationRequestController < ApplicationController
      before_action :set_vacation_request, only: %i[show approve reject]

      def index
        vacation_requests =
          if params[:status]
            VacationRequest.where(status: params[:status])
          else
            VacationRequest.where.not(status: 'rejected')
          end

        render json: vacation_requests.map { |vacation_request|
                       VacationRequestSerializer.new(vacation_request).as_json
                     }
      end

      def show
        render json: VacationRequestSerializer.new(@vacation_request).as_json
      end

      def approve
        if @vacation_request.update(update_vacation_request_params.merge(status: 'approved'))
          render json: VacationRequestSerializer.new(@vacation_request).as_json
        else
          render json: @vacation_request.errors, status: :unprocessable_entity
        end
      end

      def reject
        if @vacation_request.update(update_vacation_request_params.merge(status: 'rejected'))
          @vacation_request.worker.add_vacation_days(vacation_days: @vacation_request.total_vacation_days)
          render json: VacationRequestSerializer.new(@vacation_request).as_json
        else
          render json: @vacation_request.errors, status: :unprocessable_entity
        end
      end

      def create
        vacation_request = VacationRequest.new(create_vacation_request_params)

        if vacation_request.valid?
          vacation_request.save
          vacation_request.worker.remove_vacation_days(vacation_days: vacation_request.total_vacation_days)

          render json: VacationRequestSerializer.new(vacation_request).as_json, status: :created
        else
          render json: vacation_request.errors, status: :unprocessable_entity
        end
      end

      private

      def create_vacation_request_params
        params.require(:vacation_request).permit(:worker_id, :vacation_start_date, :vacation_end_date)
      end

      def update_vacation_request_params
        params.require(:vacation_request).permit(:id, :resolved_by_id)
      end

      def set_vacation_request
        @vacation_request = VacationRequest.find(params[:id])
      end
    end
  end
end
