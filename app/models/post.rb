class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  attachment :image

  validates :body, presence: true, length: { minimum: 2, allow_blank: true }

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end
end
