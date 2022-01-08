class FavoritesController < ApplicationController
  before_action :set_category_image, only: [:create, :destroy]

  def create
    category = @category_image.category
    favorite = current_user.favorites.new(category_image_id: @category_image.id)
    favorite.save
    @category_images = CategoryImage.includes(:image_favorited_users).where(category_id: category.id).sort{|a,b|
      b.image_favorited_users.size <=> a.image_favorited_users.size
    }
  end

  def destroy
    category = @category_image.category
    favorite = current_user.favorites.find_by(category_image_id: @category_image.id)
    favorite.destroy
    @category_images = CategoryImage.includes(:image_favorited_users).where(category_id: category.id).sort{|a,b|
      b.image_favorited_users.size <=> a.image_favorited_users.size
    }
  end

  private
  def set_category_image
    @category_image = CategoryImage.find(params[:category_image_id])
  end
end
