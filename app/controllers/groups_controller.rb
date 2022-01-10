class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_category_member, only: [:show, :edit]

  def new
    @group = Group.new
    @category = Category.find(params[:category_id])
    unless @category.users.include?(current_user)
      redirect_to group_path(@category)
    end
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
    GroupUser.find_by(user_id: current_user.id, group_id: @group.id).destroy
    redirect_to category_path(@group.category.id)
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to category_path(@group.category)
    end
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_category_member
    group = Group.find(params[:id])
    unless group.category.users.include?(current_user)
      redirect_to category_path(group.category)
    end
  end
end
