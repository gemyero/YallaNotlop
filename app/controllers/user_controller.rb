class UserController < ApplicationController

    skip_before_action :authenticate_request, only: %i[login register forget_password reset_password login_facebook login_google]
    skip_before_action :check_user, only: %i[login register forget_password reset_password login_google]

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
                        render json: {status: true, message: {id: @friend.id, name: @friend.name}}
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
            render json: {status: true, message: @group.users}
        else
            render json: {status: false, message: "friend not deleted!"}
        end
    end              

    def delete_friend_from_friend_list
        @user = User.find_by_id(params[:uid])
        # p @user
        p params[:fid]
        @friend = @user.friends.find_by_id(params[:fid])
        p @friend
        if @user and @friend
            @user.friends.delete(@friend)
            # redirect_to action: "list_user_friends", uid: params[:uid]
            # @user.friends
            render json: {status: true, message: @user.friends}
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

    def forget_password
        params.permit(:email)
        @user = User.find_by_email(params[:email])
        if @user
            token = JsonWebToken.encode(user_id: @user.id, exp: 2.hours.from_now)
            body = "<a href=\"https://localhost:3000/password/reset?token=#{token}\">link_to_front?token=#{token}</a>"
            AppMailer.send_mail(@user.email, body, 'Password Reset').deliver!
            render json: {status: true, message: "Email sent successfully!"}
        else
            render json: {status: false, message: "Email not sent!"}
        end
    end

    def reset_password
        params.permit(:password, :token)
        password = params[:password]
        token = params[:token]
        body = JsonWebToken.decode(token)
        user_id = body["user_id"]
        @user = User.find_by_id(user_id)
        if @user
            @user.update(password: password)
            render json: {status: true, message: 'password updated successfully!'}
        else
            render json: {status: false, message: 'user not found!'}
        end
    end

    def list_user_friends
        page = params[:page] || 1
        per_page = params[:per_page] || 5
        @user = User.find_by_id(params[:uid])
        if @user
            @friends = User.find(params[:uid]).friends.page(page).per(per_page)
            render json: @friends
        else
        end
    end

    def login_facebook
        params.permit(:_profile)
        @user = User.create(
            name: params[:_profile][:name],
            email: params[:_profile][:email],
            provider: 'facebook',
            password: Rails.application.secrets.secret_key_base[0..71]
        )
        if @user.save
            token = JsonWebToken.encode(user_id: @user.id)
            render json: { 
                status: true,
                token: token,
                user_id: @user.id
             }
        else
            render json: {
                status: false,
                message: @user.errors
            }
        end
    end

    def login_google
        params.permit(:profileObj)
        @user = User.create(
            name: params[:profileObj][:name],
            email: params[:profileObj][:email],
            provider: 'google',
            password: Rails.application.secrets.secret_key_base[0..71]
        )
        if @user.save
            token = JsonWebToken.encode(user_id: @user.id)
            render json: { 
                status: true,
                token: token,
                user_id: @user.id
             }
        else
            render json: {
                status: false,
                message: @user.errors
            }
        end
    end

    def fetch_user
        @user = User.find_by_id(params[:uid])
        if @user
            render json: {
                status: true,
                name: @user.name,
                email: @user.email
            }
        else
            render json: {
                status: false,
                message: "user not found!"
            }
        end
    end

    # private section 
    private
    
    def authenticate(email, password)
        command = AuthenticateUser.call(email, password)

        if command.success?
        @user = User.find_by_email(email)
        render json: {
            status: true,
            token: command.result,
            user_id: @user.id
        }
        else
        render json: { error: command.errors }, status: :unauthorized
        end
    end

end