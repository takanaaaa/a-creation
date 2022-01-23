FactoryBot.define do
  factory :relationship do
    association :user, factory: :follower_id
    association :user, factory: :followed_id
  end
end
