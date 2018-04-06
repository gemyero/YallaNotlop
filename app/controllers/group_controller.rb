class GroupController < ApplicationController

    def add_group
        params.require(:group).permit!
        params[:group][:user_id] = params[:id]
        matched_group = Group.where(user_id: params[:group][:user_id], name: params[:group][:name])[0]
        if matched_group
            render json: {status: false, message: "group already exists"}
        else
            @group = Group.new(params[:group]) 
            if @group.save
                render json: {status: true, message: "group added successfully"}
            else
                render json: {status: false, message: "error in saving the group"}
            end
        end
    end

    def delete_group
        @user = User.find_by_id(params[:id])
        @group = Group.find_by_id(params[:gid])
        if @group and @user
            @group.destroy           
            @group.users.each do |item|
                item.delete
            end
            render json: {status: true, message: "group deleted successfully"}
        else
            render json: {status: false, message: "group not deleted!"}
        end
    end

end
