require_relative "../domain/use_case/categories_usecase"

class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def initialize(categoryUsecase = CategoriesUsecase.new)
    @categoryUsecase = categoryUsecase
  end

  def index
    categories = @categoryUsecase.getCategories(current_user.id)
    render json: categories
  end

  def show
    category = @categoryUsecase.getCategoryById(params[:id])
    render json: category
  end

  def create
    if valid_category_params?(category_params)
      category = @categoryUsecase.createCategory(category_params.merge(user_id: current_user.id))
      if category.persisted?
        render json: category, status: :created
      else
        render json: category.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Nama dan deskripsi kategori tidak boleh kosong." }, status: :unprocessable_entity
    end
  end

  def update
    if valid_category_params?(category_params)
      category = @categoryUsecase.updateCategory(params[:id], category_params)
      render json: category, status: :ok
    else
      render json: { error: "Nama dan deskripsi kategori tidak boleh kosong." }, status: :unprocessable_entity
    end
  end

  def destroy
    if @categoryUsecase.deleteCategory(params[:id])
      render json: { message: "Category deleted" }, status: :ok
    else
      render json: { error: "Failed to delete" }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def valid_category_params?(params)
    params[:name].present? || params[:description].present?
  end
end
