class UsersController < ApplicationController
    before_action       

    def create
        @user = User.new(user_params)
        if @user.save
            login(@user)
            redirect_to cats_url
        else 
            redirect_to new_user_url
        end
    end

    def new
        @user = User.new 
        render :new
    end

    private

    def user_params
        params.require(:users).permit(:username, :password_digest, :session_token)
    end
end