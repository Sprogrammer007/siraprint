Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root  'static_pages#home'
  
  devise_for( :brokers, 
              :controllers  => { :registrations => "brokers" }, 
              :path => "brokers/"
            )  

  devise_for( :users, :path => "users/")

  resources :users 
  resources :pages 

  resources :brokers 
  resources :delivery_addresses
  resources :slider_images
  resources :posts

  resources :ordered_products, :only => ['update', 'destroy'] do 
    member do
      post 'upload'
    end
  end
  
  resources :large_formats, :except => ['show'] do
    member do
      post 'get_price'
      post 'change_side'
    end
  end  
	get 'large_format/:name' => 'large_formats#show', :as => 'show_large_format' 
	resources :lcds, :except => ['show'] do
    member do
      post 'get_price'
      post 'change_side'
    end
  end
	get 'lcd/:name' => 'lcds#show', :as => 'show_lcd' 
  resources :metal_signs, :path => "directional_sign", :except => ['show'] do
    member do
      post 'get_price'
    end
  end  
  get 'directional_sign/:name' => 'metal_signs#show', :as => 'show_metal_sign' 
  resources :plastic_cards, :except => ['show'] do
    member do
      post 'get_price'
    end
  end
	get 'plastic_card/:name' => 'plastic_cards#show', :as => 'show_plastic_card' 

  resources :orders, :except => ['show'] do
    member do
      get  'cancel'
      post 'remove_item'
      post 'update_item'
      get  'express'
      get  'confirm'
      patch  'pay'
      get  'select_delivery'
      get  'check_out'
      get  'invoice'
    end
  end
  
  get '/robots.:format' => 'static_pages#robots'
  get '/sitemap.:format' => 'static_pages#sitemap'
  get 'profile/:id',        to: 'accounts#show',          as: :profile
  get 'my_orders',          to: 'accounts#my_orders',     as: :my_orders
  post 'cancel',            to: 'accounts#cancel',        as: :cancel


  match  'orders/cart',          to: 'orders#show',                via: 'get', :as => 'cart'
  match  'orders/delivery_info', to: 'orders#delivery_info',       via: 'get', :as => 'delivery_info'
  match  'orders/payment',       to: 'orders#payment',             via: 'get', :as => 'payment'

  match '/help',              to: 'static_pages#help',          via: 'get'
  match '/about',             to: 'static_pages#about',         via: 'get'
  match '/portfolio',         to: 'static_pages#portfolio',     via: 'get'
  match '/contact',           to: 'static_pages#contact',       via: 'get'
  match '/contact_submit',    to: 'static_pages#contact_submit',via: 'post'
  match '/terms_of_use',      to: 'static_pages#terms',         via: 'get'
  match '/private_policy',    to: 'static_pages#privacy',       via: 'get'

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
