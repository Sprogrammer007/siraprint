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
  
  devise_scope :user do  
    get 'profile/:id', to: 'users#show', as: :user_profile
    get 'after_sign_up', to: 'users#after_sign_up'
  end
end
