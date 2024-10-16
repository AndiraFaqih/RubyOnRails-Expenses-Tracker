require_relative "../domain/use_case/users_usecase"

class UsersController < ApplicationController
  def initialize(user_usecase = UsersUsecase.new)
    @user_usecase = user_usecase
  end

  def index
    users = @user_usecase.findAll
    render json: users
  end

  def show
    user = @user_usecase.findById(params[:id])
    render json: user
  end

  # def create
  #   user = @user_usecase.create(user_params)
  #   if user
  #     render json: user, status: :created
  #   else
  #     render json: user.errors, status: :unprocessable_entity
  #   end
  # end

  def update
    user = @user_usecase.update(params[:id], user_params)
    if user
      render json: user, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user_usecase.destroy(params[:id])
      head :no_content
    else
      render json: { error: "Failed to delete" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
