class Category < ApplicationRecord
  has_many :category_users, dependent: :destroy
  has_many :users, through: :category_users
  has_many :category_images, dependent: :destroy
  has_many :groups, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 2..20, allow_blank: true }
  validates :introduction, presence: true, length: { in: 2..200, allow_blank: true }

  def category_user?(user)
    category_users.where(user_id: user.id).exists?
  end
end
