class UserController < ApplicationController

    def list_group_users
        @group = Group.find_by_id(params[:id])
        if (@group)
            render json: @group.users
        else
            render json: {message: "no such group"}
        end
    end

    def add_friend_to_group
        # Assume unique name of user
        @user = User.find_by_id(params[:uid])

        if @user
            @group = Group.find_by_id(params[:id])
            if @group
                @friend = User.find_by_name(params[:user][:name])
                if @friend
                    if @user.friends.include?(@friend)
                        if @group.users.include?(@friend)
                            # group contains friend
                            render json: {status: false, message: 'group already contain friend'}
                        else
                            @group.users << @friend
                            render json: {status: true, message: 'friend added to the group'}
                        end
                    else
                        # not in friend list
                        render json: {status: false, message: 'friend not in friends list'}
                    end
                else
                    # friend not in database asln
                    render json: {status: false, message: 'friend not in database!'}
                end
            else
                # group not found
                render json: {status: false, message: 'group not found!'}
            end
        else
            # user not found
            render json: {status: false, message: 'user not found!'}
        end
    end

    def add_friend_to_friend_list
        @user = User.find_by_id(params[:id])
        if @user
            @friend = User.find_by_email(params[:user][:email])
            if @friend 
                if @friend == @user
                    render json: {status: false, message:'you can not add yourself to your friend list!'}
                else
                    if @user.friends.include?(@friend)
                        render json: {status: false, message:'friend already in database'} 
                    else
                        @user.friends << @friend
                        render json: {status: true, message:'friend added to friend list successfully'}
                    end
                end
            else
                render json: {status: false, message:'friend not found in database'}    
            end
        else
            render json: {status: false, message:'user not found in database'}
        end        
    end

    def delete_friend_from_group
        @user = User.find_by_id(params[:uid])
        @group = @user.groups.find_by_id(params[:gid])
        @friend = @group.users.find_by_id(params[:fid])
        if @group and @user and @friend
            @friend.destroy
            render json: {status: true, message: "friend deleted successfully"}
        else
            render json: {status: false, message: "friend not deleted!"}
        end
    end              


    # need modification
    def delete_friend_from_friend_list
        @user = User.find_by_id(params[:uid])
        @friend = User.find_by_id(params[:fid])
        if @user and @friend
            # @friend.groups.each do |item|
            #     item.delete
            # end
            @user.friends.each do |item| 
                puts "*****#{item}*******"
            end
            render json: {status: true, message: "friend deleted successfully"}
        else
            render json: {status: false, message: "friend not deleted!"}
        end
    end

end