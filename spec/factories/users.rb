FactoryBot.define do
	factory :user do
		name { Faker::Lorem.characters(number:10) }
		profile { Faker::Lorem.characters(number:20) }
		email { Faker::Internet.email }
		password { 'password' }
		password_confirmation { 'password' }
	end
end