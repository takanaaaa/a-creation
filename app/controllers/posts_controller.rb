class PostsController < ApplicationController
  before_action :set_post, except: [:new, :create, :index]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = porams[:post][:name].split(nil)
    if @post.save
      @book.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post_comments = @post.post_comments.all.order(created_at: :desc)
    @post_comment = PostComment.new
  end

  def index
    @posts = Post.all
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join(" ")
  end

  def update
    tag_list = params[:post][:name].split(nil)
    if @post.update(post_params)
      @post.save_tag(tag_list)
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
