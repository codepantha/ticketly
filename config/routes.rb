# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root 'application#index'

    resources :projects, except: %i[index show]
    resources :users do
      member do
        patch :archive
      end
    end
  end

  devise_for :users

  root 'projects#index'

  resources :projects, only: %i[index show] do
    resources :tickets
  end
end
