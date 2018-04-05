class User < ApplicationRecord
    has_many :order_details
    has_and_belongs_to_many :groups
    has_many :orders
end
