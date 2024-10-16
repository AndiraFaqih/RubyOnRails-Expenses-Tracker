Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, defaults: { format: :json }  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # api/v1/users
  # api/v1/expenses
  # api/v1/categories
  resources :users, only: [:index, :show, :update, :destroy]
  resources :expenses
  resources :categories, only: [:index, :show, :create, :update, :destroy]
end
