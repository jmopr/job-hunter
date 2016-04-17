class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
    if @user
      # logged in
      # flash[:success] = "Welcome to the Sample App!"
      session[:user_id] = @user.id
      redirect_to users_jobs_path
    else
      flash[:error] = "Invalid email/password combination."
      redirect_to root_path
    end
  end
end
