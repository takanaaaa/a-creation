class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  has_many :notifications

  validates :comment, presence: true, length: { minimum: 1, allow_blank: true }

end
