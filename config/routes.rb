Rails.application.routes.draw do
  resources :journals
  resources :dashboards
  resources :tickets do
    resources :dailies
    resources :links
  end

  root 'dashboards#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
