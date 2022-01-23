class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :follower, class_name: "Reletionship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Reletionship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :bookmarks, dependent: :destroy
  has_many :category_users
  has_many :category, through: :category_users
  has_many :category_images, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :messages
  has_many :active_notifications,
    class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications,
    class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  attachment :profile_image
  attachment :home_image

  validates :name, presence: true, uniqueness: true, length: { in: 2..20, allow_blank: true }
  validates :profile, length: { maximum: 500 }

  # フォローをする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  # フォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  # フォローをされているか確かめる
  def following?(user)
    following_user.include?(user)
  end
  # フォローされた時にフォロー通知を保存する
  def create_notification_follow!(current_user)
    temp = Notification.where([
      "visiter_id = ? and visited_id = ? and action = ? ",
      current_user.id, id, 'follow',
    ])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
