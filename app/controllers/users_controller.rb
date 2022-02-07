class UsersController < ApplicationController
  before_action :set_user, except: [:index]
  before_action :ensure_correct_user, only: [:edit]

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

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to edit_user_path(current_user)
    end
  end
end
