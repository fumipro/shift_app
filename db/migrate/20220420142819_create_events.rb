class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.text :title
      t.datetime :start_time
      t.boolean :holiday, default: false
      t.date :date

      t.timestamps
    end
  end
end
