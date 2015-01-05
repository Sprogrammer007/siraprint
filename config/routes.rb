Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root  'static_pages#ud'
  
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
      post 'change_side'
    end
  end

  resources :metal_signs do
    member do
      post 'get_price'
    end
  end

  resources :orders, :except => ['show'] do
    member do
      get  'cancel'
      post 'remove_item'
      post 'update_item'
      get  'express'
      get  'confirm'
      get  'select_delivery'
      get  'check_out'
    end
  end
  
  devise_scope :user do  
    get 'profile/:id',        to: 'users#show',          as: :user_profile
    get 'my_orders',          to: 'users#my_orders',     as: :user_my_orders
    post 'cancel',            to: 'users#cancel',        as: :cancel_user
  end

  match  'orders/cart',       to: 'orders#show',                via: 'get', :as => 'cart'
  match  'orders/delivery_info', to: 'orders#delivery_info',    via: 'get', :as => 'delivery_info'
  match  'orders/payment',    to: 'orders#payment',             via: 'get', :as => 'payment'

  match '/home',              to: 'static_pages#home',          via: 'get'
  match '/help',              to: 'static_pages#help',          via: 'get'
  match '/about',             to: 'static_pages#about',         via: 'get'
  match '/contact',           to: 'static_pages#contact',       via: 'get'
end
