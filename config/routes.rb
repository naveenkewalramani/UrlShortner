Rails.application.routes.draw do

  #routes for login
  #resources :users
  get 'homepage' => "users#homepage"	#loads homepage
  get 'user/new' => "users#new"	      #go to signup page
  get 'user/login' => "users#login"   #go to login page
  post 'users/signup' => "users#Signup"      #post signup page details
  post 'users/login' => "users#Login"       #post login page details
  post 'user/show' => 'users#show'
  root "users#homepage"


  #Routes for Urls
  #root 'urls#new'
  resources :urls
  #get 'url/new' => "urls#new"
  #post 'urls' => "urls#create"
  post 'url/shorturl' => 'urls#Shorturl'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
