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

end
