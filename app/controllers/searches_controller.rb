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
      tag = Tag.where("name LIKE?", "%#{@word}%")
      @posts = Post.left_joins(:tag_maps).where(:tag_maps => { :tag_id => tag.ids })
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(12)
      if @posts.blank?
        flash[:notice] = "一致するタグがありませんでした"
        @posts = Post.page(params[:page]).per(12)
      end
    else
      @categories = Category.where("name LIKE?", "%#{@word}%").page(params[:page]).per(15)
      if @categories.blank?
        flash[:notice] = "一致するカテゴリーがありませんでした"
        @categories = Category.includes(:category_users).sort do |a, b|
          b.category_users.size <=> a.category_users.size
        end
        @categories = Kaminari.paginate_array(@categories).page(params[:page]).per(12)
      end
    end
  end
end
