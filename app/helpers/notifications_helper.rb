module NotificationsHelper
  def notification_form(notification)
    visiter = notification.visiter

    case notification.action
    when "follow" then
      tag.a(visiter.name)
      + "があなたをフォローしました。"
    when "comment" then
      tag.a(visiter.name)
      + "が"
      + tag.a('▶︎あなたの投稿', href: post_path(notification.post_id))
      + "にコメントしました。"
    when "message" then
      tag.a(visiter.name)
      + "が"
      + tag.a('▶メッセージ', href: group_messages_path(notification.group_id))
      + "を送信しました。"
      + "(" + tag.a(notification.group.name)
      + ")"
    end
  end

  def unchecked_notifications
    notifications = current_user.passive_notifications.where(checked: false)
    notifications
  end
end
