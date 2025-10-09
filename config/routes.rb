Rails.application.routes.draw do
  # API health check endpoint
  get "health" => "application#health"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy_current"
  post "sign_up", to: "registrations#create"
  get "me", to: "sessions#current"

  resources :sessions, only: [:index, :show, :destroy]

  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end

  resources :categories, only: :index
  resources :card_sets, only: :index
  resources :cards, only: :index
end
