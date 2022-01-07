Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"
  resources :users, only: [:show, :index, :edit, :update]
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
  end
  post 'follow/:id' => 'relationships#create', as: 'follow'
  post 'unfollow/:id' => 'relationships#destroy', as: 'unfollow'
  get 'users/:user_id/followings' => 'relationships#followings', as: 'followings'
  get 'users/:user_id/followers' => 'relationships#followers', as: 'followers'
end
