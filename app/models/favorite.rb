class Favorite < ApplicationRecord
  
  belongs_to :user
  belongs_to :category_image
  
end
