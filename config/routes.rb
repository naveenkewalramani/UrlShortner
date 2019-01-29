Rails.application.routes.draw do

  # Routes for sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web, :at => '/sidekiq'

  # Routes for login
  get 'homepage' => 'users#homepage'
  get 'user/new' => 'users#new'
  get 'user/login' => 'users#login'
  post 'users/signup' => 'users#signup'
  post 'users/login' => 'users#login_check'
  post 'user/show' => 'users#show'
  root 'users#homepage'
  get 'user/logout' => 'users#logout'
  
  # Routes for Urls
  resources :urls
  get 'url/long' => 'urls#search_longurl' 
  post 'urls/long' => 'urls#create_shorturl'

  # Routes for urlreport
  get 'urlreport' => 'urlreports#index'

  #Routed for elastic search
  get 'url/search' =>'search#search'
  
end
