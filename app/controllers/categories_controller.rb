class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  def show
    @category_image = CategoryImage.new
    @groups = Group.where(category_id: @category.id)
    @category_images = CategoryImage.includes(:image_favorited_users).where(category_id: @category.id).sort{|a,b|
      b.image_favorited_users.size <=> a.image_favorited_users.size
    }

  end

  def index
    @categories = Category.all
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to category_path(@category)
    else
      render :edit
    end
  end

  def join
    @category = Category.find(params[:category_id])
    unless @category.users.include?(current_user)
      @category.users << current_user
    end
  end

  def leave
    @category = Category.find(params[:category_id])
    @category.users.delete(current_user)
  end

  private
  def category_params
    params.require(:category).permit(:name, :introduction)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
