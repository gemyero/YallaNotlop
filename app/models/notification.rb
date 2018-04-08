class Notification < ApplicationRecord

    # notification associations
    belongs_to :user
    belongs_to :order

    # notification validation
    # validates :notif_type, :order_finished, :viewed, :name, presence: true

end
