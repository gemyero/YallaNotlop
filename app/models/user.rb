class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        record.errors[attribute] << (options[:message] || "is not an email")
        end
    end
end

class User < ApplicationRecord
    # encrypt password
    has_secure_password

    # user associations
    has_many :groups_created, class_name: "Group"
    has_many :order_details
    has_and_belongs_to_many :groups
    has_many :orders
    has_many :notifications
    has_and_belongs_to_many :friends, class_name: "User", 
    foreign_key: "user_id", association_foreign_key: "friend_id", 
    :join_table => 'friends'

    # user validations
    validates :name, :email, :provider, presence: true
    validates :email, :name, uniqueness: true
    validates :email, email: true
end
