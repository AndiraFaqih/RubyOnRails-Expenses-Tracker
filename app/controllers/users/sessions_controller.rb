class Users::SessionsController < Devise::SessionsController
  respond_to :json
  # before_action :check_already_logged_in, only: :create

  # POST /users/sign_in
  # This method handles user authentication and responds with a JWT token on successful login.
  def create
    sign_out(resource_name) if user_signed_in?

    user = warden.authenticate(auth_options)

    if user
      sign_out_previous_session if user_signed_in?

      token = current_token

      if token
        render json: {
          status: {
            code: 200,
            message: "Login successful"
          },
          data: UserSerializer.new(user).serializable_hash[:data][:attributes],
          token: token
        }
      else
        render json: {
          status: {
            code: 500,
            message: "JWT Token is missing or nil" 
          }
        }
      end
    else
      sign_out(resource_name) # Sign out if authentication fails
      render json: { error: "Invalid login credentials" }, status: :unauthorized
    end
  end

  # DELETE /users/sign_out
  # This method handles the logout process and can include logic to revoke JWT tokens.
  def respond_to_on_destroy
    if current_user
      Rails.logger.info "Current user: #{current_user.inspect}"
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "No user logged in" }, status: :unauthorized
    end
  end

  private

  # This method retrieves the JWT token from the Warden environment.
  def current_token
    jwt_payload = request.env["warden-jwt_auth.token"]
    jwt_payload
  end

  # This method checks if the user is already logged in to prevent duplicate logins.
  def check_already_logged_in
    if user_signed_in?
      render json: { error: "User already signed in" }, status: :forbidden
    end
  end

  # This method signs out any previously signed-in sessions to prevent conflicts.
  def sign_out_previous_session
    if user_signed_in?
      sign_out(resource_name)
    end
  end
end
