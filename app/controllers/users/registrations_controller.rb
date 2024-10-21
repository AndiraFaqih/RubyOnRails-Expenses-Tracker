# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # POST /users
  # Creates a new user.
  def create
    user = User.new(sign_up_params)

    if user.save
      render json: {
        status: { code: 201, message: 'Signed up successfully.' },
        data: UserSerializer.new(user).serializable_hash[:data][:attributes]
      }, status: :created
    else
      render json: {
        status: { code: 422, message: 'User could not be created.' },
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def sign_up_params
    params.require(:user).permit(:name, :email, :password)
  end
end
