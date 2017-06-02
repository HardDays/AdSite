Rails.application.routes.draw do
  resources :companies
  resources :users

  post 'auth/login', action: :login, controller: 'authenticate'
  post 'auth/logout', action: :logout, controller: 'authenticate'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
