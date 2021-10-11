# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VacationRequests', type: :request do
  describe 'GET /api/v1/vacation_requests' do
    let(:worker) { create(:worker) }
    let!(:vacation_requests) { create_list(:vacation_request, 10, worker: worker) }
    it 'expect to return a list of parsed vacation_requests' do
      get api_v1_vacation_request_index_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).sample).to include('id', 'author', 'request_created_at', 'vacation_start_date',
                                                          'vacation_end_date', 'status', 'resolved_by')
    end

    it 'should not include reject requests' do
      create(:vacation_request, worker: worker, status: 'rejected')
      get api_v1_vacation_request_index_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(vacation_requests.count)
    end

    context 'when a filter params is given' do
      it 'should present filtered vacation requests' do
        create(:vacation_request, worker: worker, status: 'approved')
        get api_v1_vacation_request_index_path(status: 'approved')
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(1)
        expect(JSON.parse(response.body).first['status']).to eq('approved')
      end
    end
  end

  describe 'GET /api/v1/vacation_request/:ID' do
    let(:worker) { create(:worker) }
    let!(:vacation_requests) { create_list(:vacation_request, 10, worker: worker) }
    it 'expect to return a vacation_request' do
      get api_v1_vacation_request_path(vacation_requests.first.id)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to include('id', 'author', 'request_created_at', 'vacation_start_date',
                                                   'vacation_end_date', 'status', 'resolved_by')
    end
  end

  describe 'POST /api/v1/vacation_request/' do
    let(:worker) { create(:worker) }
    it 'expect to create a vacation_request' do
      post api_v1_vacation_request_index_path, params: { vacation_request: {
        vacation_start_date: Date.today,
        vacation_end_date: Date.today + 1.day,
        worker_id: worker.id
      } }

      expect(response).to have_http_status(201)
      expect(VacationRequest.all.count).to eq(1)
      expect(worker.reload.vacation_days).to eq(30 - worker.vacation_requests.last.total_vacation_days)
    end

    context 'when the worker has not more vacation days left' do
      let(:worker) { create(:worker, vacation_days: 0) }
      it 'expect to not create a vacation and return an error' do
        post api_v1_vacation_request_index_path, params: { vacation_request: {
          vacation_start_date: Date.today,
          vacation_end_date: Date.today + 1.day,
          worker_id: worker.id
        } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ worker: ["doesn't have enough vacation days left"] }.to_json)
      end
    end

    context 'when the start_date is after the end_date' do
      it 'expect to not create a vacation and return an error' do
        post api_v1_vacation_request_index_path, params: { vacation_request: {
          vacation_start_date: Date.today + 1,
          vacation_end_date: Date.today,
          worker_id: worker.id
        } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ vacation_end_date: ['must be after the start date'] }.to_json)
      end
    end

    context 'when the start_date or end_date is in the past' do
      it 'expect to not create a vacation and return an error' do
        post api_v1_vacation_request_index_path, params: { vacation_request: {
          vacation_start_date: Date.today - 10.days,
          vacation_end_date: Date.today - 10.days,
          worker_id: worker.id
        } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq(
          {
            vacation_start_date: ['must be in the future'],
            vacation_end_date: ['must be in the future']
          }.to_json
        )
      end
    end
  end

  describe 'PUT /api/v1/vacation_request/:id/approve' do
    let(:worker) { create(:worker) }
    let(:manager) { create(:worker, role: 'manager') }
    let(:vacation_request) { create(:vacation_request, worker: worker) }

    it 'expect to approve a vacation_request' do
      put approve_api_v1_vacation_request_path(id: vacation_request.id),
          params: { vacation_request: {
            resolved_by_id: manager.id
          } }

      expect(response).to have_http_status(200)
      expect(vacation_request.reload.status).to eq('approved')
    end

    context 'when the resolver isnt a manager' do
      let(:worker) { create(:worker) }
      let(:vacation_request) { create(:vacation_request, worker: worker) }
      it 'expect not to approve a vacation_request and return an error' do
        put approve_api_v1_vacation_request_path(id: vacation_request.id),
            params: { vacation_request: {
              resolved_by_id: worker.id
            } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ resolved_by: ['must be a manager'] }.to_json)
        expect(vacation_request.status).to eq('pending')
      end
    end

    context 'when there is not resolver' do
      let(:worker) { create(:worker) }
      let(:vacation_request) { create(:vacation_request, worker: worker) }
      it 'expect not to approve a vacation_request and return an error' do
        put approve_api_v1_vacation_request_path(id: vacation_request.id),
            params: { vacation_request: {
              resolved_by_id: nil
            } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ resolved_by: ["can't be blank"] }.to_json)
        expect(vacation_request.status).to eq('pending')
      end
    end
  end

  describe 'PUT /api/v1/vacation_request/:id/reject' do
    let(:worker) { create(:worker) }
    let(:manager) { create(:worker, role: 'manager') }

    it 'expect to reject a vacation_request' do
      post api_v1_vacation_request_index_path, params: { vacation_request: {
        vacation_start_date: Date.today,
        vacation_end_date: Date.today + 1.day,
        worker_id: worker.id
      } }

      expect(worker.reload.vacation_days).to eq(29)

      put reject_api_v1_vacation_request_path(id: worker.vacation_requests.last.id),
          params: { vacation_request: {
            resolved_by_id: manager.id
          } }

      expect(response).to have_http_status(200)
      expect(worker.vacation_requests.last.reload.status).to eq('rejected')
      expect(worker.reload.vacation_days).to eq(30)
    end

    context 'when the resolver isnt a manager' do
      let(:worker) { create(:worker) }
      let(:vacation_request) { create(:vacation_request, worker: worker) }
      it 'expect not to approve a vacation_request and return an error' do
        put reject_api_v1_vacation_request_path(id: vacation_request.id),
            params: { vacation_request: {
              resolved_by_id: worker.id
            } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ resolved_by: ['must be a manager'] }.to_json)
        expect(vacation_request.status).to eq('pending')
      end
    end

    context 'when there is not resolver' do
      let(:worker) { create(:worker) }
      let(:vacation_request) { create(:vacation_request, worker: worker) }
      it 'expect not to approve a vacation_request and return an error' do
        put reject_api_v1_vacation_request_path(id: vacation_request.id),
            params: { vacation_request: {
              resolved_by_id: nil
            } }

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ resolved_by: ["can't be blank"] }.to_json)
        expect(vacation_request.status).to eq('pending')
      end
    end
  end
end
