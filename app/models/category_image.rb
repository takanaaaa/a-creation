class CategoryImage < ApplicationRecord
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :image_favorited_users, through: :favorites, source: :user

  attachment :image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
