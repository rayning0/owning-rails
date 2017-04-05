Rails.application.routes.draw do
  root to: "posts#index"
  get "/chat", to: "chat#index"
  resources :posts
end
