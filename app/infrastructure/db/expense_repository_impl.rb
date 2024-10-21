require_relative "../../domain/repositories/expense_repository"

class ExpenseRepositoryImpl < ExpenseRepository
  # Find all expenses for a given user
  def find_all_expenses(user_id)
    Expense.where(user_id: user_id)
  end

  # Find an expense by its ID
  def find_expense_by_id(id)
    Expense.find(id)
  end

  # Create a new expense with the given attributes
  def create_expense(attributes)
    Expense.create!(attributes) # Raises an exception if creation fails
  end

  # Update an existing expense identified by its ID
  def update_expense(id, attributes)
    expense = find_expense_by_id(id)
    expense.update!(attributes) # Raises an exception if update fails
    expense
  end

  # Delete an expense identified by its ID
  def destroy_expense(id)
    expense = find_expense_by_id(id)
    expense.destroy! # Raises an exception if deletion fails
  end

  # Calculate total expenses for a given month and year
  def expense_month_total(user_id, month, year)
    Expense.where(user_id: user_id)
           .where("extract(month from created_at) = ? AND extract(year from created_at) = ?", month, year)
           .sum(:amount)
  end
end
