Rails.application.routes.draw do
  root to: "requests#index"

  resources :requests do
    resources :request_drugs
    #get 'get_values', on: :member
  end

  resources :drugs
end
