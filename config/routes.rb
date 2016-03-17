Rails.application.routes.draw do
  root "welcome#index"
  resources :games, only: [:new, :create, :show, :update]

  get "/register", to: "users#new"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/dashboard", to: "users#show"
  post "/users", to: "users#create"
end
