class Post < ApplicationRecord
  belongs_to :user

  attachment :image

  validates :body, presence: true, length: { minimum: 2, allow_blank: true }
end
