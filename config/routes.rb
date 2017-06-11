Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post :login, :to => 'users/sessions#create'
        delete :logout, :to => 'users/sessions#destroy'
        post :register, :to => 'users/registrations#create'
      end

      namespace :users do 
        resources :orders, only: [:index, :create, :show]
      end

      namespace :drivers do 
        resources :orders, only: [:index, :update, :show]
      end

      devise_scope :driver do
        post :signin, :to => 'drivers/sessions#create'
        delete :signout, :to => 'drivers/sessions#destroy'
      end
    	resources :products, only: [:index, :show]
    end
  end

  devise_for :drivers
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "admin/orders#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
