Rails.application.routes.draw do
  namespace :api do
    resources :configurations, only: [:index]
    resources :status, only: [:index]
    resources :schedules, only: [:create]
  end
end
