class MessagesController < ApplicationController

  def create
    @group = Group.find(params[:group_id])
    @message = @group.messages.create(message_params)
    @messages = @group.messages.includes(:user)
    @message.save
    @group.create_notification_message!(current_user, @message.id)
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end
end
