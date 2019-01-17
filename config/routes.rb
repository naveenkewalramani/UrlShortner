Rails.application.routes.draw do
  get 'user/new' => "users#new"
  post 'users' => "users#create"
  root 'users#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
