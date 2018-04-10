class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :state, default: 'waiting'
      t.string :order_for, default: 'breakfast'
      t.string :restaurant
      t.text :menu_img
      t.integer :invited, default: 0
      t.integer :joined, default: 0
      t.belongs_to :user
      t.timestamps
    end
  end
end
