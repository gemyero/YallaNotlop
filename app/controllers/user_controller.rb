class UserController < ApplicationController

    skip_before_action :authenticate_request, only: %i[login register]
    skip_before_action :check_user, only: %i[login register]
    # before_action :check_user, except: [:login, :register]

    def list_group_users
        @user = User.find_by_id(params[:uid])
        @group = @user.groups_created.find_by_id(params[:gid])
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
            @group = Group.find_by_id(params[:gid])
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
        @user = User.find_by_id(params[:uid])
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
        @group = @user.groups_created.find_by_id(params[:gid])
        @friend = @group.users.find_by_id(params[:fid])
        if @group and @user and @friend
            @group.users.delete(@friend)
            render json: {status: true, message: "friend deleted from group successfully"}
        else
            render json: {status: false, message: "friend not deleted!"}
        end
    end              

    def delete_friend_from_friend_list
        @user = User.find_by_id(params[:uid])
        @friend = @user.friends.find_by_id(params[:fid])
        if @user and @friend
            @user.friends.delete(@friend)
            render json: {status: true, message: "friend deleted from friendlist successfully"}
        else
            render json: {status: false, message: "friend not deleted!"}
        end
    end

    def register
        user_params = params.permit(:name, :email, :password)
        @user = User.create(user_params)
        if @user.save
            response = { message: 'User created successfully'}
            render json: { status: true, message: 'User created successfully' }
        else
            render json: { status: false, message: @user.errors }
        end 
    end

    def login
        authenticate params[:email], params[:password]
    end

    # private section 
    private
    
    def authenticate(email, password)
        command = AuthenticateUser.call(email, password)

        if command.success?
        render json: {
            access_token: command.result,
            message: 'Login Successful'
        }
        else
        render json: { error: command.errors }, status: :unauthorized
        end
    end

    # def check_user
    #     if @current_user.id != params[:uid].to_i
    #         render json: {status: false, message: "You are not allowed to access this information!"}
    #     end
    # end

end