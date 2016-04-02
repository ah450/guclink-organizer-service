Rails.application.routes.draw do
  namespace :api do
    resources :configurations, only: [:index]
  end
end
