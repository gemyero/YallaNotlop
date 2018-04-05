class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :type
      t.boolean :opened
      t.belongs_to :user
      t.timestamps
    end
  end
end
