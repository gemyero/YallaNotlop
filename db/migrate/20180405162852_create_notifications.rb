class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :notif_type
      t.boolean :order_finished, default: false
      t.boolean :viewed, default: false
      t.belongs_to :user
      t.belongs_to :order
      t.string :name
      t.timestamps
    end
  end
end
