FactoryBot.define do
  factory :notification do
    visiter_id { FactoryBot.create(:user).id }
    visited_id { FactoryBot.create(:user).id }
    post_id { FactoryBot.create(:post).id }
    post_comments_id { FactoryBot.create(:post_comment).id }
    checked { "false" }
  end
end
