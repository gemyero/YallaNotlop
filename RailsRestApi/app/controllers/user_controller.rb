class UserController < ApplicationController

    def list_group_users
        @group = Group.find_by_id(params[:id])
        if (@group)
            render json: @group.users
        else
            render json: {message: "no such group"}
        end
    end

    # def add_user_to_group
    #     # Assume unique name of user
    #     @group = Group.find_by_id(params[:id])
    #     if @group
    #         @user = User.find_by_name(params[:user][:name]) 
    #         if @user
    #             @group.users << @user
    #             render json: {status: true, message: 'user added to the group'}
    #         else
    #             render json: {status: false, message: 'user is not found'}
    #         end
    #     else
    #         render json: {status: false, message: 'group is not found'}            
    #     end
    # end

end