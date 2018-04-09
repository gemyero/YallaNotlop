class OrderController < ApplicationController

    def add_order
        params.require(:order).permit!
        p params[:order]       
        @user = User.find_by_id(params[:uid])

        if @user
            params[:order][:user_id] = params[:uid]
            @order = Order.create(params[:order])

            if @order.save
                @all_friends = @user.friends
                @all_friends.each{ |friend|
                    ActionCable.server.broadcast "activities_#{friend.id}",{
                        order_id: @order[:id],
                        name: @user.name,
                        restaurant: @order.restaurant,
                        order_for: @order.order_for
                    } 
                }
            end

            params[:friends].each { |friend|
                # p @user.friends.find_by_id(friend)
                friend = friend[:id]
                if @user.friends.find_by_id(friend)
                    @notif = Notification.create(user_id: friend, notif_type: "invite", 
                                        order_finished: false, order_id: @order[:id],
                                        name: @user.name, viewed: false)
                    p @notif
                    if @notif.save
                        ActionCable.server.broadcast "notifications_#{friend}",{
                            type: "invite",
                            order_id: @order[:id],
                            name: @user.name
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

    def list_user_orders
        page = params[:page] || 1
        per_page = params[:per_page] || 5
        @user = User.find_by_id(params[:uid])
        joined = 0
        invited = 0
        if @user
            @orders = Order.page(page).per(per_page).where(user_id: @user.id)
            @orders.each do |order|
                order.notifications.each do |notification|
                    if notification.notif_type == 'invite'
                        invited += 1
                    else
                        joined +=1
                    end
                end
                order[:joined] = joined
                order[:invited] = invited
                joined = 0
                invited = 0
            end
            render json: @orders
        else
        end
    end

    # def get_friends_orders

    # end

end
