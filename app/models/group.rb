class Group < ApplicationRecord

  has_many :group_users
  has_many :users, through: :group_users
  has_many :messages, dependent: :destroy
  belongs_to :category

  validates :name, presence: true
  validates :introduction, presence: true

  def group_member?(user)
    group_users.where(user_id: user.id).exists?
  end
  
  def create_notification_message!(current_user, message_id)
    member_ids = Message.select(:user_id).where(group_id: id).where.not(user_id:current_user.id).distinct
    member_ids.each do |memder_id|
      save_notification_message!(current_user, message_id, memder_id['user_id'])
    end
    save_notification_message!(current_user, message_id, user_id) if member_ids.blank?
  end
  
  def save_notification_message!(current_user, message_id, visited_id)
    notification = current_user.active_notifications.new(
        group_id: id,
        message_id: message_id,
        visited_id: visited_id,
        action: 'message'
      )
      
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
  end
end
