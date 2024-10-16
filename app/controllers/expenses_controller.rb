require_relative "../domain/use_case/expenses_usecase"
require_relative "../domain/use_case/categories_usecase"

class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def initialize(expenseUsecase = ExpenseUsecase.new, categoryUsecase = CategoriesUsecase.new)
    @expenseUsecase = expenseUsecase
    @categoryUsecase = categoryUsecase
  end

  def index
    begin
      expenses = @expenseUsecase.findAllExpenses(current_user.id)
      render json: expenses
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expenses not found" }, status: :not_found
    end
  end

  def show
    begin
      expense = @expenseUsecase.findExpenseById(params[:id])
      if expense.nil?
        render json: { error: "Expense not found" }, status: :not_found
      elsif expense.user_id == current_user.id
        render json: expense
      else
        render json: { error: "You are not authorized to view this expense" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    end
  end

  def create
    if valid_expense_params?(expense_params)
      user_id = current_user.id
      category_name = expense_params[:category_name]

      category = @categoryUsecase.getCategoryByName(category_name, user_id)

      if category
        expense = @expenseUsecase.createExpense(expense_params.merge(user_id: user_id, category_id: category.id))
        if expense.persisted?
          render json: expense, status: :created
        else
          render json: { error: "Failed to create expense" }, status: :unprocessable_entity
        end
      else
        render json: { error: "Category not found" }, status: :not_found
      end
    else
      render json: { error: "Amount or description is required" }, status: :unprocessable_entity
    end
  end

  def update
    begin
      expense = @expenseUsecase.findExpenseById(params[:id])
      if expense.user_id == current_user.id
        if valid_expense_params?(expense_params)
          updated_expense = @expenseUsecase.updateExpense(params[:id], expense_params.merge(user_id: current_user.id, category_id: params[:category_id]))
          render json: updated_expense, status: :ok
        else
          render json: { error: "Amount or description is required" }, status: :unprocessable_entity
        end
      else
        render json: { error: "You are not authorized to update this expense" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    end
  end

  def destroy
    puts "cuurent user id: #{current_user.id}"
    begin
      expense = @expenseUsecase.findExpenseById(params[:id])
      puts "expense user id: #{expense.user_id}"
      if expense.user_id == current_user.id
        if @expenseUsecase.destroyExpense(params[:id])
          render json: { message: "Expense deleted" }, status: :ok
        else
          render json: { error: "Failed to delete" }, status: :unprocessable_entity
        end
      else
        render json: { error: "You are not authorized to delete this expense" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :description, :category_name)
  end

  def valid_expense_params?(params)
    params[:amount].present? || params[:description].present?
  end
end
