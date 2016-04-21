class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    @user.document = user_params[:document]
    unless user_params[:github] == ""
      @user.number_of_lines, @user.number_of_projects = @user.get_the_bytes(user_params[:github])
    end
    if @user.save
      log_in @user
      flash[:success] = "Signed up was successful! Welcome, #{@user.first_name}!"
      redirect_to users_jobs_path
    else
      render 'new'
    end
  end

  def update
    current_user.update(user_params)
    redirect_to users_jobs_path
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :first_name,
                    :last_name, :email, :phone_number, :github, :linkedin, :document)
    end
end
