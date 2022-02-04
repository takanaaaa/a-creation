class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]
    if @range == 'user'
      @users = User.where("name LIKE?", "%#{@word}%").page(params[:page]).per(15)
      if @users.blank?
        flash[:notice] = "一致するユーザーがいませんでした"
        @users = User.page(params[:page]).per(15)
      end
    elsif @range == 'post'
      @posts = Post.left_joins(:tags).where("tags.name LIKE?", "%#{@word}%").order(created_at: :desc).page(params[:page]).per(12).distinct
      if @posts.blank?
        flash[:notice] = "一致するタグがありませんでした"
        @posts = Post.order(created_at: :desc).page(params[:page]).per(12)
      end
    else
      @categories = Category.where("name LIKE?", "%#{@word}%").page(params[:page]).per(15)
      if @categories.blank?
        flash[:notice] = "一致するカテゴリーがありませんでした"
        @categories = Category.includes(:category_users).sort do |a, b|
          b.category_users.size <=> a.category_users.size
        end
      else
        @categories = Kaminari.paginate_array(@categories).page(params[:page]).per(12)
      end
    end
  end
end
