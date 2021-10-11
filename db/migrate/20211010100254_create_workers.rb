# frozen_string_literal: true

class CreateWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      t.string :name
      t.string :last_name
      t.string :role
      t.string :email
      t.integer :vacation_days, default: 30

      t.timestamps
    end
  end
end
