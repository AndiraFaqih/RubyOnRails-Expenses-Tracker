require_relative "../../domain/repositories/expense_repository"

class ExpenseRepositoryImpl < ExpenseRepository
  def findAllExpenses(userId)
    expenses = Expense.where(user_id: userId)
    expenses
  end

  def findExpenseById(id)
    expense = Expense.find(id)
    expense
  end

  def createExpense(attributes)
    expenses = Expense.create!(attributes)
    expenses
  end

  def updateExpense(id, attributes)
    expense = Expense.find(id)
    expense.update!(attributes)
    expense
  end

  def destroyExpense(id)
    expense = Expense.find(id)
    expense.destroy!
  end
end
