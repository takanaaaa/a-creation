FactoryBot.define do
	factory :category do
		name { Faker::Lorem.characters(10) }
		introduction { Faker::Lorem.characters(20) }
	end
end