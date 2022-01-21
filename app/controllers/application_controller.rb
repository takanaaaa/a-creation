class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, unless: :devise_or_homes_controller?

  protected

  def set_user
    @user = User.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_current_user
    post = Post.find(params[:id])
    unless post.user == current_user
      redirect_to posts_path
    end
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || user_path(current_user)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
  end
  
  def store_current_location
    store_location_for(:user, request.url)
  end
  
  def devise_or_homes_controller?
    devise_controller? || controller_name == 'homes'
  end
end
