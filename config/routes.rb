Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
    	resources :products, only: [:index, :show]
    end
  end

  devise_for :drivers
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
