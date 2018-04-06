class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :notif_type
      t.boolean :opened
      t.belongs_to :user
      t.belongs_to :order
      t.timestamps
    end
  end
end
