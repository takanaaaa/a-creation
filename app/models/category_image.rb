class CategoryImage < ApplicationRecord
  belongs_to :category

  attachment :image
  
end
