class PostsController < ApplicationController
  before_action :set_post, except: [:new, :create, :index]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
  end

  def index
    @posts = Post.all
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def destroy
    Post.find_by(id: @post.id).destroy
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:body, :image)
  end

end
