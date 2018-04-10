class OrdersChannel < ApplicationCable::Channel  
    def subscribed
        stream_from "orders_#{current_user.id}"
      end
  end  