class OrderController < ApplicationController

    def add_order
        params.require(:order).permit!
        @user = User.find_by_id(params[:id])
        if @user
            params[:order][:user_id] = params[:id]
            Order.create(params[:order])
            render json: {status: true, message: "group added successfully"}
        else
            render json: {status: false, message: "no user with id = #{params[:id]}"}
        end        
    end

    def delete_order
       
        @order = Order.where(user_id: params[:id], id: params[:oid])[0]

        if @order
            @order.destroy
            render json: {status: true, message: "order canceled"}
        else
            render json: {status: false, message: "failed to delete the order"}
        end      
    end

end
