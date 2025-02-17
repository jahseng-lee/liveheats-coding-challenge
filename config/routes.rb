Rails.application.routes.draw do
  root "home#index"

  resources :students, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check
  get "*path", to: "home#index"
end
