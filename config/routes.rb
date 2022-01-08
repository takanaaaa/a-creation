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
    resources :groups, except: [:show, :index]
    get 'join' => 'categories#join'
    delete 'leave' => 'categories#leave'
  end
  resources :groups, only: [:show] do
    resources :messages, only: [:create, :index]
    get 'join' => 'groups#join'
    delete 'leave' => 'groups#leave'
  end
  resources :notifications, only: [:index]
  delete 'notifications/destroy_all' => 'notifications#destroy_all', as: 'notification'
  post 'follow/:id' => 'relationships#create', as: 'follow'
  post 'unfollow/:id' => 'relationships#destroy', as: 'unfollow'
  post 'category_images/:category_image_id/favorite' => 'favorites#create', as: 'favorites'
  delete 'category_images/:category_image_id/favorite' => 'favorites#destroy', as: 'favorite'
end
