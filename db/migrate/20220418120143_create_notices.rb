class CreateNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :notices do |t|
      t.text :title
      t.text :content

      t.timestamps
    end
  end
end
