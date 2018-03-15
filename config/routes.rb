Rails.application.routes.draw do
  resources :homepage, only: 'index'

  # Route the home page as the root
  root to: 'homepage#index'

  mount Qa::Engine => '/qa'

  resources :usage, only: 'index'
  resources :authority_status, only: 'index'

  get 'dashboard', controller: 'authority_status'
  get 'authorities', controller: 'authority_status'
end
