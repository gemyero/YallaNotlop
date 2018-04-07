class NotificationController < ApplicationController
    
    def get_all_notifications
        if User.find_by_id(params[:id])
            @notifications = Notification.where(user_id: params[:id])
            render json: {status: true, message: @notifications}
        else
            render json: {status: false, message: "failed to get notifications"}
        end        
    end
    
    def join_order
        params.require(:notification).permit! 

        if User.find_by_id(params[:id])
            Notification.create({name: params[:name], order_id: params[:order_id],
                                user_id: params[:id], order_finished: false, notif_type: "join"})
            render json: {status: true, message: "notification added"}
        else
            render json: {status: false, message: "failed to add notification"}
        end
    end
    
end
