class OrderDetailController < ApplicationController

    def add_order_details
        params.require(:order_detail).permit!
        p params
        @order_invite = Notification.where(order_id: params[:order_id], user_id: params[:uid])[0]

        if @order_invite
            params[:order_detail][:user_id] = params[:uid]
            newOrder = OrderDetail.create(params[:order_detail])
            @notifications = Notification.where(params[:order_id])
            @notifications.each { |notif|
                if notif.user_id != params[:uid]
                    ActionCable.server.broadcast "orders_#{notif.user_id}", newOrder
                end
            }            
            render json: {status: true, message: "order details added successfully"}
        else
            render json: {status: false, message: "you don not have invitation"}
        end
    end

    def delete_order_details

        @order_detail = OrderDetail.where(id: params[:oid], user_id: params[:uid])[0]
        if @order_detail
            @order_id = @order_detail[:order_id]
            @order = Order.where(id: @order_id)[0]

            if @order and @order[:state] == "waiting"
                @order_detail.destroy
                render json: {status: true, message: "order details deleted successfully"}
            else
                render json: {status: false, message: "failed to delete the order"}
            end 
        else
            render json: {status: false, message: "failed to delete the order"}
        end       
    end

    def get_order_details
        @orderDetails = OrderDetail.where(order_id: params[:oid]);
        render json: {status: true, message: @orderDetails}           
    end
end
