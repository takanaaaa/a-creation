# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# ユーザー作成
50.times do |n|
User.create!(
  name: "テスト#{n + 1}",
  profile: "プロフィール#{n + 1}",
  email: Faker::Internet.email,
  password: "123456",
)
end

# フォローフォロワー作成
# followedが5分の1の確率でfollowerをフォローする
reletionship_list = []
User.all.ids.each do |followed_id|
  User.all.ids.each do |follower_id|
    if rand(5) == 0 && followed_id != follower_id
      reletionship_list << {
        followed_id: followed_id,
        follower_id: follower_id
      }
    end
  end
end
Reletionship.create!(reletionship_list)

50.times do |n|
Post.create!(
  user_id: Faker::Number.between(from: 1, to: 50),
  body: "本文#{n + 1}",
)
end

80.times do |n|
PostComment.create!(
  user_id: Faker::Number.between(from: 1, to: 50),
  post_id: Faker::Number.between(from: 1, to: 50),
  comment: "コメント#{n + 1}",
)
end

80.times do |n|
Bookmark.create!(
  user_id: Faker::Number.between(from: 1, to: 50),
  post_id: Faker::Number.between(from: 1, to: 50),
)
end

100.times do |n|
Tag.create!(
  name: "タグ#{n + 1}",
)
end

100.times do |n|
TagMap.create!(
  post_id: Faker::Number.between(from: 1, to: 50),
  tag_id: Faker::Number.between(from: 1, to: 100),
)
end

30.times do |n|
Category.create!(
  name: "カテゴリー名#{n + 1}",
  introduction: "カテゴリー紹介#{n + 1}",
)
end


category_image_list = []
CategoryUser.all.each do |category_user|
  if rand(2) == 0
    category_image_list << {
      category_id: category_user.category.id,
      user_id: category_user.user.id,
      image: open("./app/assets/images/no-image.jpg")
    }
  end
end
CategoryImage.create!(category_image_list)

favorite_list = []
CategoryImage.all.ids.each do |category_image_id|
  User.all.ids.each do |user_id|
    if rand(3) == 0 
      favorite_list << {
        category_image_id: category_image_id,
        user_id: user_id
      }
    end
  end
end
Favorite.create!(favorite_list)

60.times do |n|
CategoryUser.create!(
  category_id: Faker::Number.between(from: 1, to: 30), 
  user_id: Faker::Number.between(from: 1, to: 50),
)
end

group_list = []
CategoryUser.all.each do |category_user|
  group_list << {
    name: "グループ名#{category_user.id}",
    introduction: "グループ紹介#{category_user.id}",
    category_id: category_user.category.id,
    owner_id: category_user.user.id,
  }
end
Group.create!(group_list)

group_user_list = []
Category.all.each do |category|
  category.users.each do |user|
    category.groups.each do |group|
      if rand(2) == 0
        group_user_list << {
          user_id: user.id,
          group_id: group.id
        }
      end
    end
  end
end
# グループ作成者をグループメンバーに追加
Group.all.each do |group|
  group_owner_list = {
    user_id: group.owner_id,
    group_id: group.id
  }
end
GroupUser.create!(group_user_list)

# グループメンバーのメッセージを送信
messages_list = []
GroupUser.all.each do |group_user|
  if rand(2) == 0
    messages_list << {
      user_id: group_user.user.id,
      group_id: group_user.group.id,
      content: "メッセージ#{group_user.id}"
    }
  end
end
Message.create!(messages_list)