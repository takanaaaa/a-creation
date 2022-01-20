FactoryBot.define do
  factory :post do
    body { Faker::Lorem.characters(20) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpeg')) }
    user
  end
end
