FactoryBot.define do
	factory :category_image do
		category
		user
		image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpeg'))}
	end
end