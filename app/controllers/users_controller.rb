require_relative "../domain/use_case/users_usecase"

class UsersController < ApplicationController
  def initialize(user_usecase = UsersUsecase.new)
    @user_usecase = user_usecase
  end

  # GET /users
  # Retrieves a list of users.
  # @return [JSON] a JSON response containing all users
  def index
    begin
      users = @user_usecase.find_all
      render json: {
        status: {
          code: 200,
          message: 'Success'
        },
        data: {
          users: users
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Users not found" }, status: :not_found
    end
  end

  # GET /users/:id
  # Retrieves a user by their ID.
  # @param id [Integer] the ID of the user to retrieve
  # @return [JSON] a JSON response containing the user data
  def show
    begin
      user = @user_usecase.find_by_id(params[:id])
      render json: {
        status: {
          code: 200,
          message: 'Success'
        },
        data: {
          user: user
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    end
  end

  # PUT /users/:id
  # Updates an existing user identified by ID.
  # @param id [Integer] the ID of the user to update
  # @return [JSON] a JSON response containing the updated user data
  def update
    begin
      user = @user_usecase.update(params[:id], user_params)
      render json: {
        status: {
          code: 200,
          message: "Success"
        },
        data: {
          user: user
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to update user" }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  # Deletes a user identified by ID.
  # @param id [Integer] the ID of the user to delete
  # @return [JSON] a JSON response indicating success or failure
  def destroy
    begin
      @user_usecase.destroy(params[:id])
      render json: {
        status: {
          code: 200, 
          message: "Success"
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to delete user" }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for user creation and updates.
  # @return [Hash] permitted user attributes
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
