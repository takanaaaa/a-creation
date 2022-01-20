class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == 'user'
      @users = User.where("name LIKE?","%#{@word}%").page(params[:page]).per(15)
      unless @users.present?
        flash[:notice] = "一致するユーザーがいませんでした"
        @users = User.page(params[:page]).per(15)
      end
    elsif @range == 'post'
      tag = Tag.where("name LIKE?","%#{@word}%")
        @posts = Post.left_joins(:tag_maps).where(:tag_maps => {:tag_id => tag.ids})
        @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(12)
      unless @posts.present?
        flash[:notice] = "一致するタグがありませんでした"
        @posts = Post.page(params[:page]).per(12)
      end
    else
      @categories = Category.where("name LIKE?","%#{@word}%").page(params[:page]).per(15)
      unless @categories.present?
        flash[:notice] = "一致するカテゴリーがありませんでした"
        @categories = Category.page(params[:page]).per(15)
      end
    end
  end
end
