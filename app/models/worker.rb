# frozen_string_literal: true

class Worker < ApplicationRecord
  has_many :vacation_requests

  def add_vacation_days(vacation_days:)
    self.vacation_days += vacation_days
    save
  end

  def remove_vacation_days(vacation_days:)
    self.vacation_days -= vacation_days
    save
  end
end
