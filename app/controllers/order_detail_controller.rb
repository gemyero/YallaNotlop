class OrderDetailController < ApplicationController

    def add_order_details
        params.require(:order_detail).permit!

        @order_invite = Notification.where(order_id: params[:order_id], user_id: params[:uid])[0]
        @creator = Order.where(user_id: params[:uid], id: params[:order_id])[0]
        @state = Order.find_by_id(params[:order_id])[:state]

        if @state == "waiting"
            if @order_invite or @creator
                params[:order_detail][:user_id] = params[:uid]
                newOrder = OrderDetail.create(params[:order_detail])
                @notifications = Notification.where(order_id: params[:order_id])                
              
                joined = []
                 @notifications.each { |notif|
                    joined.push(notif.user_id)                   
                }
                joined.push(Order.find_by_id(params[:order_id])[:user_id])
                
                joined.each {|one|
                    if one != params[:uid].to_i
                        ActionCable.server.broadcast "orders_#{one}", {order: newOrder, name: User.find_by_id(params[:uid])[:name], action: "add"}
                    end
                }     
                render json: {status: true, message: {order: newOrder, name: User.find_by_id(params[:uid])[:name]}}
            else
                render json: {status: false, message: "you don not have invitation"}
            end
        else
            render json: {status: false, message: "sorry order finished"}
        end
        
    end

    def delete_order_details

        @order_detail = OrderDetail.where(id: params[:oid], user_id: params[:uid])[0]
        @order_id = @order_detail[:order_id]
        @state = Order.find_by_id(@order_id)[:state]

        if @state == "waiting"
            if @order_detail
                @order = Order.where(id: @order_id)[0]
    
                if @order and @order[:state] == "waiting"
                    @order_detail.destroy
                    @notifications = Notification.where(order_id: @order_id)                
    
                    joined = []
                     @notifications.each { |notif|
                        joined.push(notif.user_id)                   
                    }
                    joined.push(Order.find_by_id(@order_id)[:user_id])
                    
                    joined.each {|one|
                        if one != params[:uid].to_i
                            ActionCable.server.broadcast "orders_#{one}", {order: @order_detail, name: User.find_by_id(params[:uid])[:name], action: "delete"}
                        end
                    }     
                    
                    render json: {status: true, message: "order details deleted successfully"}
                else
                    render json: {status: false, message: "failed to delete the order"}
                end 
            else
                render json: {status: false, message: "failed to delete the order"}
            end       
        else
            render json: {status: false, message: "sorry order finished"}
        end
       
    end

    def get_order_details
        @names = []
        @orderDetails = OrderDetail.where(order_id: params[:oid]);
        @order = Order.find_by_id(params[:oid])
        @state = @order[:state]        
        @orderDetails.each {|order|
            user = order.user.name
            @names.push(user)
        }
        render json: {status: true, message: {orders: @orderDetails, names: @names, state: @state, menu_img: @order[:menu_img]}}           
    end
end
