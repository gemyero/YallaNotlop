class NotificationController < ApplicationController
    
    def get_all_notifications
        if User.find_by_id(params[:uid])
            @notifications = Notification.where(user_id: params[:uid])
            render json: {status: true, message: @notifications}
        else
            render json: {status: false, message: "failed to get notifications"}
        end        
    end
    
    def join_order
        params.require(:notification).permit! 

        if User.find_by_id(params[:uid])
            @notif = Notification.create({name: params[:name], order_id: params[:order_id],
                                user_id: params[:uid], order_finished: false, notif_type: "join"})
            if @notif.save
                ActionCable.server.broadcast "notifications_#{params[:uid]}",{
                message: "join",
                order_id: params[:order_id],
                name: params[:name]
                }                       
            end                    
            render json: {status: true, message: "notification added"}
        else
            render json: {status: false, message: "failed to add notification"}
        end
    end

    def view_notifications
        if User.find_by_id(params[:uid])
            Notification.where(user_id: params[:uid]).update_all(viewed: true) 
            render json: {status: true, message: "notification viewed"}
        else
            render json: {status: false, message: "failed to view notifications"}
        end
    end 
    
    def get_new_notifications
        if User.find_by_id(params[:uid])
            @notifs = Notification.where(user_id: params[:uid], viewed: false)
            @notifiacations = Notification.where(user_id: params[:uid]).last(2)
            count = @notifs.length
            render json: {status: true, count: count, notifications: @notifiacations}
        else
            render json: {error: "ddd"}
        end
    end 
end
