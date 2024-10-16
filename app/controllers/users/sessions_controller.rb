# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    Rails.logger.info "Start login process"
    Rails.logger.info "Auth Options: #{auth_options.inspect}"

    user = warden.authenticate!(auth_options)

    if user
      Rails.logger.info "User authenticated: #{user.inspect}"
      token = current_token
      if token
        Rails.logger.info "JWT Token: #{token}"
        render json: {
          token: token,
          user: user
        }, status: :created
      else
        Rails.logger.info "Failed to generate token"
        render json: { error: 'Token generation failed' }, status: :unprocessable_entity
      end
    else
      Rails.logger.info "Authentication failed for email: #{params[:user][:email]}"
      render json: { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end

  def destroy
    super do |resource|
      if resource.errors.empty?
        render json: { message: 'Logged out successfully' }, status: :ok
      end
    end
  end

  private

  def current_token
    jwt_payload = request.env['warden-jwt_auth.token']
    Rails.logger.info "JWT Payload: #{jwt_payload}"
    jwt_payload
  end
end
