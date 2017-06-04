Rails.application.routes.draw do

  resources :ads
  #Authentication routes

  post 'auth/login', action: :login, controller: 'authenticate'
  post 'auth/logout', action: :logout, controller: 'authenticate'

  #User routes

  get 'users/all', action: :index, controller: 'users'
  get 'users/info/:id', action: :show, controller: 'users'
  get 'users/my_info', action: :my_info, controller: 'users'
  post 'users/create', action: :create, controller: 'users'
  put 'users/update/:id', action: :update, controller: 'users'
  delete 'users/delete/:id', action: :delete, controller: 'users'

  #Access routes

  get 'access/user_access/:id', action: :user_access, controller: 'access'
  get 'access/my_access', action: :my_access, controller: 'access'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
