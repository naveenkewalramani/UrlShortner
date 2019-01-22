Rails.application.routes.draw do

  #routes for login
  #resources :users
  get 'homepage' => "users#homepage"	#loads homepage
  get 'user/new' => "users#new"	      #go to signup page
  get 'user/login' => "users#login"   #go to login page
  post 'users/signup' => "users#signup"      #post signup page details
  post 'users/login' => "users#login_new"       #post login page details
  post 'user/show' => 'users#show'
  root "users#homepage"
  get 'user/logout' => "users#logout"

  require 'sidekiq/web'
  mount Sidekiq::Web, :at => '/sidekiq'
  
  #Routes for Urls
  resources :urls
  post 'url/shorturl' => 'urls#Shorturl'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
