class Group < ApplicationRecord
    
    # group associations
    belongs_to :user
    has_and_belongs_to_many :users

    # group validations
    validates :name, presence: true
end
