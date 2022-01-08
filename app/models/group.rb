class Group < ApplicationRecord

  has_many :group_users
  has_many :users, through: :group_users
  belongs_to :category

  validates :name, presence: true
  validates :introduction, presence: true

  def group_member?(user)
    group_users.where(user_id: user.id).exists?
  end
end
