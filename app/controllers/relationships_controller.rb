class RelationshipsController < ApplicationController
  before_action :set_user, only: [:create, :destroy]

  def create
    current_user.follow(@user.id)
    @user.create_notification_follow!(current_user)
  end

  def destroy
    current_user.unfollow(@user.id)
  end

  def followings
    @user = User.find(params[:user_id])
    @users = @user.following_user
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.follower_user
  end
end
