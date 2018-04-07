class OrderController < ApplicationController

    def add_order
        params.require(:order).permit!       
        @user = User.find_by_id(params[:uid])

        if @user
            params[:order][:user_id] = params[:uid]
            @order = Order.create(params[:order])

            params[:friends].each { |friend|
                if @user.friends.find_by_id(friend)
                    notif = Notification.create({user_id: friend, notif_type: "invite", 
                                        order_finished: false, order_id: @order[:id],
                                        name: @user.name, viewed: false})
                    if notif.save
                        ActionCable.server.broadcast "notifications_#{friend}",{
                            message: "#{@user.name} invited you to join his order",
                            order_id: @order[:id]
                        }
                       
                    end
                end
            }

            render json: {status: true, message: "order added successfully"}
        else
            render json: {status: false, message: "no user with id = #{params[:uid]}"}
        end        
    end

    def delete_order
       
        @order = Order.where(user_id: params[:uid], id: params[:oid])[0]

        if @order
            @order.destroy
            render json: {status: true, message: "order canceled"}
        else
            render json: {status: false, message: "failed to delete the order"}
        end      
    end

    def change_state
       
        @order = Order.where(user_id: params[:uid], id: params[:oid])[0]

        if @order
            @order.state = "finished"
            if @order.save
                Notification.where(order_id: params[:oid]).update_all(order_finished: true)                
                render json: {status: true, message: "order finished"}
            else
                render json: {status: false, message: "failed to finish the order"}
            end
        else
            render json: {status: false, message: "failed to finish the order"}
        end      

    end

end
