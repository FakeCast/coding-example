# frozen_string_literal: true

FactoryBot.define do
  factory :vacation_request do
    vacation_start_date { Date.today + 5.days }
    vacation_end_date { Date.today + 10.days }
    status { 'pending' }
  end
end
