class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
    if @user
      # logged in
      session[:user_id] = @user.id
      redirect_to users_path
    else
      render action: 'new'
    end
  end
end
