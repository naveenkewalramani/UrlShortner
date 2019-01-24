Rails.application.routes.draw do

  #routes for login
  get 'homepage' => 'users#homepage'
  get 'user/new' => 'users#new'
  get 'user/login' => 'users#login'
  post 'users/signup' => 'users#signup'
  post 'users/login' => 'users#login_new'
  post 'user/show' => 'users#show'
  root 'users#homepage'
  get 'user/logout' => 'users#logout'

  #routes for sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web, :at => '/sidekiq'
  
  #Routes for Urls
  resources :urls
 
  get 'url/long' => 'urls#long'
  post 'url/shorturl' => 'urls#Shorturl'

  #Routes for urlreport
  get 'urlreport' => 'urlreports#index'
  
end
