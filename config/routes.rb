Rails.application.routes.draw do
  # Use Devise for user authentication, customizing the controllers for registrations and sessions.
  # This ensures all requests will expect JSON responses by default.
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }, defaults: { format: :json }

  # Define a health check route for the application, useful for monitoring system health.
  # The route responds to GET requests on "/up" and returns a 200 status if the app is running smoothly.
  get "up" => "rails/health#show", as: :rails_health_check

  # RESTful routes for users. Supports index (list all users), show (show a user),
  # update (edit user details), and destroy (delete a user).
  resources :users, only: [ :index, :show, :update, :destroy ]

  # RESTful routes for expenses with additional custom routes for monthly and yearly summaries.
  resources :expenses do
    # Custom collection routes for generating monthly and yearly expense summaries.
    collection do
      get "monthly_summary"
      get "yearly_summary"
    end
  end

  # RESTful routes for categories. Supports index, show, create, update, and destroy actions.
  resources :categories, only: [ :index, :show, :create, :update, :destroy ]
end
