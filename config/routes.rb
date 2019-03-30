Rails.application.routes.draw do
  root to: "requests#index"

  resources :requests
end
