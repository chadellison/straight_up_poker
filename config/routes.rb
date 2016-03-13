Rails.application.routes.draw do
  root "welcome#index"
  resources :games, only: [:new, :create, :show]

  get "/register", to: "users#new"
  get "/dashboard", to: "users#show"
  post "/users", to: "users#create"
end
