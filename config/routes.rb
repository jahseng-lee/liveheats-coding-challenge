Rails.application.routes.draw do
  root "home#index"

  resources :races, only: [:index, :show, :create, :update]
  resources :students, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check
  get "*path", to: "home#index"
end
