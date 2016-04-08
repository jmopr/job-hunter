class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new user_params
    if @user.save
      redirect_to root_path, notice: "Created user"
    else
      render action: 'new'
    end
  end
  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
