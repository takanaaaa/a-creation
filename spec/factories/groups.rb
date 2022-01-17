FactoryBot.define do
	factory :group do
		name { Faker::Lorem.characters(10) }
		introduction { Faker::Lorem.characters(20) }
		owner_id { FactoryBot.create(:user).id }
		category
		user
	end
end