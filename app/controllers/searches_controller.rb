class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == 'user'
      @users = User.where("name LIKE?","%#{@word}%")
      unless @users.present?
        flash[:notice] = "一致するユーザーがいませんでした"
        @users = User.all
      end
    elsif @range == 'post'
      tag = Tag.where("name LIKE?","%#{@word}%")
        @posts = Post.left_joins(:tag_maps).where(:tag_maps => {:tag_id => tag.ids})
      unless @posts.present?
        flash[:notice] = "一致するタグがありませんでした"
        @posts = Post.all
      end
    else
      @categories = Category.where("name LIKE?","%#{@word}%")
      unless @categories.present?
        flash[:notice] = "一致するカテゴリーがありませんでした"
        @categories = Category.all
      end
    end
  end
end
