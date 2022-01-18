class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def show
    @posts = @user.posts.page(params[:page]).per(12)
  end

  def index
    @users = User.page(params[:page]).per(15)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :profile_image, :home_image)
  end

end
