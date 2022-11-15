class SessionsController < ApplicationController

    def new
        @user = User.new
        render :new
    end


    def create
        @user = User.find_by_credentials(params[:user][:username], params[:user][:username])
        if @user
            login(@user)
            redirect_to cats_url #index page
        else
            render :new
        end

    end

    def destroy
        # logout
        # redirect_to new_session_url
        if current_user.session_token == session[:session_token]
            current_user.reset_session_token!
        end  
        session[:session_token] = nil

    end




end