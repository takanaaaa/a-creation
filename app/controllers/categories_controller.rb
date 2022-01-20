class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.users << current_user
    if @category.save
      redirect_to category_path(@category)
    else
      render :new
    end
  end

  def show
    @category_image = CategoryImage.new
    @groups = Group.includes(:group_users).where(category_id: @category.id).sort do |a, b|
      b.group_users.size <=> a.group_users.size
    end
    @category_images =
      CategoryImage.includes(:favorited_users).where(category_id: @category.id).sort do |a, b|
        b.favoriters.size <=> a.favorited_users.size
      end
    @category_images = Kaminari.paginate_array(@category_images).page(params[:page]).per(15)
  end

  def index
    @categories = Category.includes(:category_users).sort do |a, b|
      b.category_users.size <=> a.category_users.size
    end
    @categories = Kaminari.paginate_array(@categories).page(params[:page]).per(12)
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
