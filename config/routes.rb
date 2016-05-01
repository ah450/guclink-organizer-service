Rails.application.routes.draw do
  namespace :api do
    resources :configurations, only: [:index]
    resources :status, only: [:index]
    resources :schedules, only: [:create, :index]
    resources :exams, only: [:create, :index]
    resources :courses, only: [:index, :show]
    resources :events, only: [:create, :index, :show, :destroy] do
      member do
        put :like
        put :unlike
      end
    end
    resources :subscriptions, only: [:index, :destroy]

    resources :event_invitations, only: [:create, :index, :destroy, :show] do
      member do
        put :reject
        put :accept
      end
    end
    
    resources :notifications, only: [:create] do
      collection do
        get :sent
        get :received
      end
    end
    resources :gcm_ids, only: [:create]
  end
end
