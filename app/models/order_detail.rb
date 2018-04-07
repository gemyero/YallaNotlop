class OrderDetail < ApplicationRecord

    # order_detail associations
    belongs_to :user
    belongs_to :order

    # order_detail validations
    validates :item, :amount, :price, presence: true

end
