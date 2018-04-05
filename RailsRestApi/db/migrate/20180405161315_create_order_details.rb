class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details do |t|
      t.belongs_to :user
      t.belongs_to :order
      t.string :item
      t.integer :amount
      t.integer :price
      t.text :comment

      t.timestamps
    end
  end
end
