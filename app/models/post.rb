class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  attachment :image

  validates :body, presence: true, length: { minimum: 2, allow_blank: true }

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  def create_notification_comment!(current_user, comment_id)
    unless user_id == current_user.id
    save_notification_comment!(current_user, comment_id, user_id)
    end
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comments_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
