class HomesController < ApplicationController

  def top
    images = CategoryImage.includes(:image_favorited_users).sort{|a,b|
      b.image_favorited_users.size <=> a.image_favorited_users.size
    }
    @top_images = images.first(5)
  end
end
