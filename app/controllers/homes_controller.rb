class HomesController < ApplicationController
  def top
    images = CategoryImage.includes(:favorited_users).sort do |a, b|
      b.favorited_users.size <=> a.favorited_users.size
    end
    @top_images = images.first(5)
  end
end
