Rails.application.routes.draw do
  #Authentication routes

  post 'auth/login', action: :login, controller: 'authenticate'
  post 'auth/logout', action: :logout, controller: 'authenticate'

  #User routes

  get 'users/all', action: :index, controller: 'users'
  get 'users/info/:id', action: :show, controller: 'users'
  get 'users/my_info', action: :my_info, controller: 'users'
  get 'users/get_my_likes', action: :get_my_likes, controller: 'users'
  get 'users/get_my_rates', action: :get_my_rates, controller: 'users'
  get 'users/get_likes/:id', action: :get_likes, controller: 'users'
  post 'users/create', action: :create, controller: 'users'
  post 'users/rate', action: :rate, controller: 'users'
  post 'users/unrate', action: :unrate, controller: 'users'
  post 'users/like', action: :like, controller: 'users'
  post 'users/unlike', action: :unlike, controller: 'users'
  put 'users/change_password', action: :change_password, controller: 'users'
  put 'users/update/:id', action: :update, controller: 'users'
  put 'users/update_me', action: :update_me, controller: 'users'
  delete 'users/delete/:id', action: :delete, controller: 'users'

  #Access routes

  get 'access/user_access/:id', action: :user_access, controller: 'access'
  get 'access/my_access', action: :my_access, controller: 'access'
  post 'access/grant_admin_access/:user_id', action: :grant_admin_access_route, controller: 'access'

  #Ads routes

  get 'ads/all', action: :index, controller: 'ads'
  get 'ads/info/:id', action: :show, controller: 'ads'
  post 'ads/create', action: :create, controller: 'ads'
  put 'ads/update/:id', action: :update, controller: 'ads'
  delete 'ads/delete/:id', action: :delete, controller: 'ads'

  #News routes

  get 'news/all', action: :index, controller: 'news'
  get 'news/info/:id', action: :show, controller: 'news'
  post 'news/create', action: :create, controller: 'news'
  put 'news/update/:id', action: :update, controller: 'news'
  delete 'news/delete/:id', action: :delete, controller: 'news'

  #Images routes
  get 'images/info/:id', action: :show, controller: 'images'

  #Reviews routes

  get 'reviews/all', action: :index, controller: 'reviews'
  get 'reviews/info/:id', action: :show, controller: 'reviews'
  post 'reviews/create', action: :create, controller: 'reviews'
  put 'reviews/update/:id', action: :update, controller: 'reviews'
  delete 'reviews/delete/:id', action: :delete, controller: 'reviews'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
