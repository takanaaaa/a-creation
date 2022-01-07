class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy

  attachment :image

  validates :body, presence: true, length: { minimum: 2, allow_blank: true }
end
