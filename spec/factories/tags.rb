FactoryBot.define do
  factory :tags do
    name { Faker::Lorem.characters(number: 10) }
  end
end
