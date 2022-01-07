class Category < ApplicationRecord

  has_many :category_users
  has_many :users, through: :category_users

  validates :name, presence: true, uniqueness: true


  def category_user?(user)
    category_users.where(user_id: user.id).exists?
  end

end
