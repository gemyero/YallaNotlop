class Order < ApplicationRecord

    # order associations
    has_many :order_details, dependent: :destroy
    belongs_to :user
    has_many :notifications, dependent: :destroy

    # order validations
    validates :state, :order_for, :restaurant, presence: true

end
