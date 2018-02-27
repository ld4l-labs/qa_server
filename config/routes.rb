Rails.application.routes.draw do
  resources :homepage, only: 'index'

  # Route the home page as the root
  root to: 'homepage#index'

  mount Qa::Engine => '/qa'

  resources :authority_status, only: 'index'
end
