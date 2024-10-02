# frozen_string_literal: true

Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  get 'sessions/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get    'login', to: 'sessions#new'
  post   'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users, only: %i[index show new create edit update destroy] do
    resources :relationships, only: %i[create destroy]
    resources :followees, only: %i[index], module: :users
    resources :followers, only: %i[index], module: :users
  end

  resources :posts, only: %i[index show new create edit update destroy] do
    resources :favorites, only: %i[create destroy]
    resources :comments,  only: %i[show create]
  end

  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end
