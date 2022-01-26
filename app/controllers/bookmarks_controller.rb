class BookmarksController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    Bookmark.create(user_id: current_user.id, post_id: @post.id)
  end

  def index
    @user = User.find(params[:user_id])
    bookmarks = Bookmark.where(user_id: current_user.id).pluck(:post_id)
    @bookmark_list = Post.find(bookmarks)
    @bookmark_list = Kaminari.paginate_array(@bookmark_list).page(params[:page]).per(12)
  end

  def destroy
    @post = Post.find(params[:post_id])
    Bookmark.find_by(user_id: current_user.id, post_id: @post.id).destroy
  end
end
