# frozen_string_literal: true

class VacationRequest < ApplicationRecord
  belongs_to :worker
  belongs_to :resolved_by, class_name: 'Worker', optional: true
  validate :worker_must_have_vacation_days, on: [:create]
  validates :vacation_start_date, :vacation_end_date, :status, presence: true
  validates :resolved_by, presence: true, on: [:update]
  validate :vacation_end_date_after_vacation_start_date
  validate :dates_must_be_in_future
  validate :resolver_must_be_a_manager, on: [:update]

  def total_vacation_days
    return if vacation_start_date.blank? || vacation_end_date.blank?
    (vacation_end_date - vacation_start_date).to_i
  end

  private

  def vacation_end_date_after_vacation_start_date
    return if vacation_end_date.blank? || vacation_start_date.blank?

    errors.add(:vacation_end_date, 'must be after the start date') if vacation_end_date < vacation_start_date
  end

  def dates_must_be_in_future
    return if vacation_end_date.blank? || vacation_start_date.blank?

    errors.add(:vacation_start_date, 'must be in the future') if vacation_start_date < Date.today

    errors.add(:vacation_end_date, 'must be in the future') if vacation_end_date < Date.today
  end

  def worker_must_have_vacation_days
    return if worker.blank? || total_vacation_days.blank?

    errors.add(:worker, "doesn't have enough vacation days left") if worker.vacation_days < total_vacation_days
  end

  def resolver_must_be_a_manager
    return if resolved_by.blank?

    errors.add(:resolved_by, 'must be a manager') if resolved_by.role != 'manager'
  end
end
