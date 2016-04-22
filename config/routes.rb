Rails.application.routes.draw do
  namespace :api do
    resources :configurations, only: [:index]
    resources :status, only: [:index]
    resources :schedules, only: [:create]
    resources :exams, only: [:create, :index, :show]
    resources :courses, only: [:index, :show]
    resources :events, only: [:create, :index, :show] do
      member do
        put :like
        put :unlike
      end
      resources :subscriptions, only: [:create, :index, :destroy]
    end
  end
end
