class OrderDetailController < ApplicationController

    def add_order_details
        params.require(:order_detail).permit!
        @user = User.find_by_id(params[:id])
        if @user
            @order = Order.find_by_id(params[:order_detail][:order_id])
            if @order
                params[:order_detail][:user_id] = params[:id]
                OrderDetail.create(params[:order_detail])
                render json: {status: true, message: "order details added successfully"}
            else
                render json: {status: false, message: "no order with id = #{params[:order_detail][:order_id]}"} 
            end            
        else
            render json: {status: false, message: "no user with id = #{params[:id]}"}
        end
    end

    def delete_order_details

        @order_detail = OrderDetail.where(id: params[:oid], user_id: params[:id])[0]
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
end
