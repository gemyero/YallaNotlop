class ApplicationController < ActionController::API
    include ActionController::Helpers
    helper_method :current_user
    before_action :authenticate_request
    before_action :check_user
 
    
    attr_reader :current_user
    
    include ExceptionHandler

    # [...]
    private
    def authenticate_request
        @current_user = AuthorizeApiRequest.call(request.headers).result       
        render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

    def check_user
        if @current_user.id != params[:uid].to_i
            render json: {status: false, message: "You are not allowed to access this information!"}
        end
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end