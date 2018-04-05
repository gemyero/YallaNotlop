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

end