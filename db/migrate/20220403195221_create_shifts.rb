class CreateShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :shifts do |t| 
      t.time :begin_time
      t.time :finish_time
      t.date :date
      t.datetime :start_time

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
