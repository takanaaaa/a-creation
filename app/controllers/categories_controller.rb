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

  private
  def category_params
    params.require(:category).permit(:name, :introduction)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
