require_relative "../domain/use_case/expenses_usecase"
require_relative "../domain/use_case/categories_usecase"

class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def initialize(expense_usecase = ExpenseUsecase.new, category_usecase = CategoriesUsecase.new)
    @expense_usecase = expense_usecase
    @category_usecase = category_usecase
  end

  # GET /expenses
  # Retrieves all expenses for the current user.
  def index
    begin
      expenses = @expense_usecase.find_all_expenses(current_user.id)
      render json: {
        status: {
          code: 200,
          message: "Success"
        },
        data: {
          expenses: expenses
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expenses not found" }, status: :not_found
    end
  end

  # GET /expenses/:id
  # Retrieves a specific expense by ID for the current user.
  def show
    begin
      expense = @expense_usecase.find_expense_by_id(params[:id])
      if expense.nil?
        render json: {
          status: {
            code: 404,
            message: "Expense Not Found"
          }
        }
      elsif expense.user_id == current_user.id
        render json: {
          status: {
            code: 200,
            message: "Success"
          },
          data: {
            expense: expense
          }
        }
      else
        render json: {
          status: {
            code: 403,
            message: "You are not authorized to view this expense"
          }
        }
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    end
  end

  # POST /expenses
  # Creates a new expense for the current user.
  def create
    begin
      if valid_expense_params?(expense_params)
        user_id = current_user.id
        category_name = expense_params[:category_name]

        category = @category_usecase.get_category_by_name(category_name, user_id)

        if category
          expense = @expense_usecase.create_expense(expense_params.merge(user_id: user_id, category_id: category.id))
          if expense.persisted?
            render json: {
              status: {
                code: 201,
                message: "Created"
              },
              data: {
                expense: expense
              }
            }
          else
            render json: {
              status: {
                code: 422,
                message: "Unprocessable Entity - Failed to create expense"
              }
            }
          end
        else
          render json: {
            status: {
              code: 404,
              message: "Category not found"
            }
          }
        end
      else
        render json: {
          status: {
            code: 422,
            message: "Amount or description is required"
          }
        }
      end
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to create" }, status: :unprocessable_entity
    end
  end

  # PATCH /expenses/:id
  # Updates an existing expense for the current user.
  def update
    begin
      expense = @expense_usecase.find_expense_by_id(params[:id])
      if expense.user_id == current_user.id
        if valid_expense_params?(expense_params)
          updated_expense = @expense_usecase.update_expense(params[:id], expense_params)
          render json: {
            status: {
              code: 200,
              message: "Success"
            },
            data: {
              expense: updated_expense
            }
          }
        else
          render json: {
            status: {
              code: 422,
              message: "Amount or description is required"
            }
          }
        end
      else
        render json: {
          status: {
            code: 403,
            message: "You are not authorized to update this expense"
          }
        }
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to update" }, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/:id
  # Deletes an existing expense for the current user.
  def destroy
    begin
      expense = @expense_usecase.find_expense_by_id(params[:id])
      if expense.user_id == current_user.id
        if @expense_usecase.destroy_expense(params[:id])
          render json: {
            status: {
              code: 200,
              message: "Success"
            }
          }
        else
          render json: { error: "Failed to delete" }, status: :unprocessable_entity
        end
      else
        render json: { error: "You are not authorized to delete this expense" }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { error: "Failed to delete" }, status: :unprocessable_entity
    end
  end

  # GET /expenses/monthly_summary
  # Retrieves the total expenses for a specific month and year for the current user.
  def monthly_summary
    month = params[:month]
    year = params[:year]
    begin
      total = @expense_usecase.expense_month_total(current_user.id, month, year)
      render json: { message: "Total expenses for month #{month} of year #{year} is #{total}" }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    end
  end

  # GET /expenses/yearly_summary
  # Retrieves the total expenses for a specific year for the current user.
  def yearly_summary
    month = Time.now.month
    year = params[:year]
    begin
      total = @expense_usecase.expense_year_total(current_user.id, month, year)
      render json: total
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Expense not found" }, status: :not_found
    end
  end

  private

  # Strong parameters for expense
  def expense_params
    params.require(:expense).permit(:amount, :description, :category_name)
  end

  # Validates expense parameters to ensure at least one of the fields is present
  def valid_expense_params?(params)
    params[:amount].present? || params[:description].present?
  end
end
