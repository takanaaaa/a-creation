Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"
  resources :users, only: [:show, :index, :edit, :update] do
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'bookmarks' => 'bookmarks#index', as: 'bookmarks'
  end
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :bookmarks, only: [:create, :destroy]
  end
  resources :categories, except: [:destroy] do
    resources :category_images, only: [:create]
    get 'join' => 'categories#join'
    delete 'leave' => 'categories#leave'
  end
  post 'follow/:id' => 'relationships#create', as: 'follow'
  post 'unfollow/:id' => 'relationships#destroy', as: 'unfollow'
end
