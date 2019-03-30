Rails.application.routes.draw do
  root to: "requests#index"

  resources :requests do
    resources :request_drugs
  end

  resources :drugs
end
