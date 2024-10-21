require_relative "../domain/use_case/categories_usecase"

class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def initialize(category_usecase = CategoriesUsecase.new)
    @category_usecase = category_usecase
  end

  # GET /categories
  # Retrieve all categories for the current user
  def index
    begin
      categories = @category_usecase.get_categories(current_user.id)
      render json: {
        status: {
          code: 200,
          message: "Success"
        },
        data: {
          categories: categories
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Categories not found" }, status: :not_found
    end
  end

  # GET /categories/:id
  # Retrieve a category by its ID
  def show
    begin
      category = @category_usecase.get_category_by_id(params[:id])
      if category.nil?
        render json: {
          status: {
            code: 404,
            message: "Category Not Found"
          }
        }
      elsif category.user_id == current_user.id
        render json: {
          status: {
            code: 200,
            message: "Success"
          },
          data: {
            category: category
          }
        }
      else
        render json: {
          status: {
            code: 403,
            message: "You are not authorized to view this category"
          }
        }
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Category not found" }, status: :not_found
    end
  end

  # POST /categories
  # Create a new category
  def create
    begin
      if valid_category_params?(category_params)
        user_id = current_user.id
        category = @category_usecase.create_category(category_params.merge(user_id: user_id))
        if category.persisted?
          render json: {
            status: {
              code: 201,
              message: "Created"
            },
            data: {
              category: category
            }
          }
        else
          render json: {
            status: {
              code: 422,
              message: "Unprocessable Entity - Failed to create category"
            }
          }
        end
      else
        render json: {
          status: {
            code: 422,
            message: "Name and description cannot be empty"
          }
        }
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Category not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to create" }, status: :unprocessable_entity
    end
  end

  # PATCH /categories/:id
  # Update an existing category
  def update
    begin
      if valid_category_params?(category_params)
        category = @category_usecase.update_category(params[:id], category_params)
        if category.nil?
          render json: {
            status: {
              code: 404,
              message: "Category Not Found"
            }
          }
        elsif category.user_id == current_user.id
          render json: {
            status: {
              code: 200,
              message: "Success"
            },
            data: {
              category: category
            }
          }
        else
          render json: {
            status: {
              code: 403,
              message: "You are not authorized to update this category"
            }
          }
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Category not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to update" }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:id
  # Delete a category by its ID
  def destroy
    begin
      category = @category_usecase.get_category_by_id(params[:id]).user_id
      if category == current_user.id
        @category_usecase.delete_category(params[:id])
        render json: {
          status: {
            code: 200,
            message: "Success"
          }
        }
      else
        render json: { error: "You are not authorized to delete this category" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Category not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to delete" }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for category
  def category_params
    params.require(:category).permit(:name, :description)
  end

  # Validate category parameters
  def valid_category_params?(params)
    params[:name].present? && params[:description].present?
  end
end
