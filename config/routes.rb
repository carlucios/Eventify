# frozen_string_literal: true

Rails.application.routes.draw do
  mount SolidQueueDashboard::Engine, at: '/solid-queue'

  root 'dashboard#index'

  devise_for :users

  resources :events

  resources :articles do
    member do
      get :file_view
    end
  end

  resources :follows, only: [:create, :destroy] do
    post :toggle, on: :collection
  end
  
  resources :notifications, only: [:index] do
    collection do
      patch :mark_all_as_read
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  match '*unmatched', to: redirect('/'), via: :get
end
