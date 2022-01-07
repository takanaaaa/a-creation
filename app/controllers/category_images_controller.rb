class CategoryImagesController < ApplicationController

  def create
    category_image = CategoryImage.new(category_image_params)
    category = Category.find(params[:category_id])
    category_image.category_id = category.id
    category_image.save
    redirect_back(fallback_location: root_path)
  end

  private
  def category_image_params
    params.require(:category_image).permit(:image)
  end
end
