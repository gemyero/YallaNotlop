class User < ActiveRecord::Base
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
    validates :email, uniqueness: true

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
            user.provider = auth.provider
            user.id = auth.uid
            user.name = auth.info.name
            user.save!
        end
    end
end


# class User < ActiveRecord::Base
#     def self.from_omniauth(auth)
#       where(provider: auth.provider, id: auth.uid).first_or_initialize.tap do |user|
#         user.provider = auth.provider
#         user.id = auth.uid
#         user.name = auth.info.name
#         user.save!
#       end
#     end
#   end