class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
    if @user
      # logged in
      flash[:success] = "Welcome to the Job Hunter, #{@user.first_name}!"
      log_in @user
      redirect_to users_jobs_path
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
