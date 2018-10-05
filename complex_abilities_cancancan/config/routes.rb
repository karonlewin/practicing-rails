Rails.application.routes.draw do
  devise_for :users
  resources :issues
  resources :user_permissions
  resources :sectors
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
