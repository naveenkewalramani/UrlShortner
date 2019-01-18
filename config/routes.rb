Rails.application.routes.draw do

  #routes for login		
  get 'user/new' => "users#new"
  post 'users' => "users#create"
  root 'users#new'


  #Routes for Urls
  #root 'urls#new'
  resources :urls
  get 'url/new' => "urls#new"
  post 'urls' => "urls#create"
  post 'url/shorten' => 'urls#show_long_url'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
