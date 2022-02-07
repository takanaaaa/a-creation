class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum status: { apply: 0, join: 1 }, _prefix: true
end
