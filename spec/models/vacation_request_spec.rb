# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VacationRequest, type: :model do
  let!(:worker) { FactoryBot.create(:worker) }
  let!(:manager) { FactoryBot.create(:worker, role: 'manager') }
  let(:vacation_request) { FactoryBot.create(:vacation_request, worker: worker, resolved_by: manager) }

  it 'is valid with valid attributes' do
    expect(vacation_request).to be_valid
  end

  it 'is not valid without a worker' do
    vacation_request.worker = nil
    expect(vacation_request).to_not be_valid
  end

  it 'is not valid without a vacation start date' do
    vacation_request.vacation_start_date = nil
    expect(vacation_request).to_not be_valid
  end

  it 'is not valid without an vacation end date' do
    vacation_request.vacation_end_date = nil
    expect(vacation_request).to_not be_valid
  end

  it 'is not valid without a status' do
    vacation_request.status = nil
    expect(vacation_request).to_not be_valid
  end

  it 'is not valid without a start date after the end date' do
    vacation_request.vacation_start_date = Date.today + 1.day
    vacation_request.vacation_end_date = Date.today
    expect(vacation_request).to_not be_valid
  end

  it 'is not valid without a start date before the current date' do
    vacation_request.vacation_start_date = Date.today - 1.day
    expect(vacation_request).to_not be_valid
  end

  it 'is not valid if the worker has not available vacation days' do
    worker.vacation_days = 0
    expect(
      VacationRequest.create(
        worker: worker,
        vacation_start_date: Date.today,
        vacation_end_date: Date.today + 1.day
      )
    ).to_not be_valid
  end

  it 'cannot be approved/reject if the resolver isnt a manager' do
    vacation_request.resolved_by = FactoryBot.create(:worker, role: 'worker')
    expect(vacation_request).to_not be_valid
  end
end
