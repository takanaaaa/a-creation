module NotificationsHelper

  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    @visiter_comment = notification.post_comment

    case notification.action
      when "follow" then
        tag.a(@visiter.name)+"があなたをフォローしました"
      when "comment" then
        @comment = PostComment.find_by(id: @visiter_comment)&.content
        tag.a(@visiter.name)+"が"+tag.a('あなたの投稿', href:post_path(notification.post_id))+"にコメントしました"
      end
  end
  
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
