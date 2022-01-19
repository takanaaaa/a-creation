class MessagesController < ApplicationController
  before_action :set_group, only: [:create, :index]

  def create
    @message = @group.messages.create(message_params)
    @messages = @group.messages.includes(:user)
    unless @message.save
      render :index, notice: "メッセージを入力してください"
    end
    if @messages.count == 1
      redirect_back(fallback_location: root_path)
    end
    @group.create_notification_message!(current_user, @message.id)
  end

  def index
    @message = Message.new
    @messages = @group.messages.includes(:user)
  end

  private
  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
