# frozen_string_literal: true

class VacationRequestSerializer < ActiveModel::Serializer
  def as_json
    {
      id: object.id,
      author: object.worker.id,
      status: object.status,
      resolved_by: object.resolved_by_id,
      request_created_at: object.created_at,
      vacation_start_date: object.vacation_start_date.to_datetime,
      vacation_end_date: object.vacation_start_date.to_datetime
    }
  end
end
