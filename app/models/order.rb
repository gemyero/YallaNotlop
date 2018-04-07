class Order < ApplicationRecord
    has_many :order_details, dependent: :destroy
    belongs_to :user
    has_many :notifications, dependent: :destroy
end
