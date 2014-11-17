Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root  'static_pages#home'
  
  devise_for( :users, 
              :controllers  => { :registrations => "users", :sessions => "sessions" }, 
              :path => ""
            )

  resources :users
  resources :delivery_addresses
  resources :slider_images
  resources :posts
  
  resources :large_formats do
    member do
      post 'get_price'
    end
  end

  resources :metal_signs do
    member do
      post 'get_price'
    end
  end

  resources :orders, :except => ['show'] do
    member do
      get 'cancel'
      post 'remove_item'
      post 'update_item'
    end
  end
  
  devise_scope :user do  
    get 'profile/:id',        to: 'users#show',          as: :user_profile
    get 'after_sign_up',      to: 'users#after_sign_up'
    get 'my_orders',          to: 'users#my_orders',     as: :user_my_orders
  end

  match  'orders/cart',       to: 'orders#show',                via: 'get', :as => 'cart'
  match  'orders/delivery_info', to: 'orders#delivery_info',    via: 'get', :as => 'delivery_info'
  match  'orders/payment',    to: 'orders#payment',             via: 'get', :as => 'payment'

  match '/help',              to: 'static_pages#help',          via: 'get'
  match '/about',             to: 'static_pages#about',         via: 'get'
  match '/contact',           to: 'static_pages#contact',       via: 'get'
end
