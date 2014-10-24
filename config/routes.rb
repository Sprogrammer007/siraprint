Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root  'static_pages#home'
  
  devise_for( :users, 
              :controllers  => { :registrations => "users" }, 
              :path => ""
            )

  resources :users
  resources :delivery_addresses
  resources :large_prints do
    member do
      post 'get_thickness'
      post 'get_price'
    end
  end
  resources :orders, :except => ['show'] do
    member do
      post 'remove_item'
      post 'update_item'
      get 'delivery_info'
    end
  end
  
  devise_scope :user do  
    get 'profile/:id', to: 'users#show', as: :user_profile
    get 'after_sign_up', to: 'users#after_sign_up'
  end

  get  'orders/cart' => 'orders#show', :as => 'cart'

end
