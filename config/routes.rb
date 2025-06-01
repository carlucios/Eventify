# frozen_string_literal: true

Rails.application.routes.draw do
  mount SolidQueueDashboard::Engine, at: '/solid-queue'
  devise_for :users

  resources :events
  resources :articles
  resources :follows, only: %i[create destroy]
  resources :articles do
    member do
      get :file_view
    end
  end

  root 'dashboard#index'
  post '/toggle_follow', to: 'follows#toggle', as: :toggle_follow

  get 'up' => 'rails/health#show', as: :rails_health_check
end
