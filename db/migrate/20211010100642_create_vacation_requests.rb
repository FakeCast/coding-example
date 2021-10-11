# frozen_string_literal: true

class CreateVacationRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :vacation_requests do |t|
      t.references :worker, null: false, foreign_key: true
      t.references :resolved_by, index: true, foreign_key: { to_table: :workers }
      t.date :vacation_start_date
      t.date :vacation_end_date
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
