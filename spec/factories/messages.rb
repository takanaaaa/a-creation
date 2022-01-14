FactoryBot.define do
	factory :message do
		content { Faker::Lorem.characters(20) }
		group
		user
	end
end