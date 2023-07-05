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

    resources :states, only: %i[index new create] do
      member do
        patch :make_default
      end
    end
  end

  devise_for :users

  root 'projects#index'

  resources :projects, only: %i[index show] do
    resources :tickets do
      collection do
        get :search
      end
      member do
        patch :watch
      end
    end
  end

  scope path: 'tickets/:ticket_id/', as: :ticket do
    resources :comments, only: [:create]
    delete 'tags/:id/remove', to: 'tags#remove', as: :remove_tag
  end
end
