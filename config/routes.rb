Rails.application.routes.draw do
  resources :tickets do
    resources :dailies
  end

  root 'tickets#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
