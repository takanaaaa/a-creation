class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
     @category = Category.find(params[:category_id])
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    @category = Category.find(params[:category_id])
    @group.category_id = @category.id
    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました。"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @group.save
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  def join
    @group = Group.find(params[:group_id])
    unless @group.users.include?(current_user)
      @group.users << current_user
      redirect_to group_path(@group)
    end
  end

  def leave
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to category_path(@group.category.id)
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == currect_user.id
      redirect_to posts_path
    end
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
