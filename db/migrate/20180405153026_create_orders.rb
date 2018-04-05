class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :state
      t.string :order_for
      t.belongs_to :user
      t.timestamps
    end
  end
end
