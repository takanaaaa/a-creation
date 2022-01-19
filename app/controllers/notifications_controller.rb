class NotificationsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to user_notifications_path(current_user.id)
  end
end
