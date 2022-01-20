class PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    @post_comments = @post.post_comments.all.order(created_at: :desc)
    @post.create_notification_comment!(current_user, comment.id)
  end

  def destroy
    PostComment.find_by(id: params[:id]).destroy
    @post = Post.find(params[:post_id])
    @post_comments = @post.post_comments.all.order(created_at: :desc)
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
