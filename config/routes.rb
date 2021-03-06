Rails.application.routes.draw do
  root 'pages#home'
  
  get '/home', to: 'pages#home'
  
  resources :recipes do
    member do
      post 'like'
    end
  end
  
  resources :chefs, except: [:new, :destroy]
  get '/register', to: 'chefs#new'  # custom route to register new chef
  
  # custom routes for user login/logout
  get '/login', to: "logins#new"
  post '/login', to: "logins#create"
  get '/logout', to: "logins#destroy"
  
end
