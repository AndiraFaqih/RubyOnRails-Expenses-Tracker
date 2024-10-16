require_relative "../../infrastructure/db/expense_repository_impl"

class ExpenseUsecase
  def initialize(expense_repository = ExpenseRepositoryImpl.new)
    @expense_repository_impl = expense_repository
  end

  def findAllExpenses(userId)
    begin
      expenses = @expense_repository_impl.findAllExpenses(userId)
      expenses

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expenses tidak ditemukan.")
    end
  end

  def findExpenseById(expenseId)
    begin
      expense = @expense_repository_impl.findExpenseById(expenseId)
      return nil unless expense
      expense

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expense dengan ID #{expenseId} tidak ditemukan.")
    end
  end

  def createExpense(attributes)
    excludeAttributes = attributes.except(:category_name)
    begin
      expense = @expense_repository_impl.createExpense(excludeAttributes)
      expense

    rescue StandardError => e
      raise e
    end
  end

  def updateExpense(id, attributes)
    begin
      attributesToUpdate = {}
      attributesToUpdate[:amount] = attributes[:amount] if attributes[:amount].present?
      attributesToUpdate[:description] = attributes[:description] if attributes[:description].present?

      expense = @expense_repository_impl.updateExpense(id, attributesToUpdate)
      expense

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expense dengan ID #{id} tidak ditemukan.")
    end
  end

  def destroyExpense(id)
    begin
      expense = findExpenseById(id)
      @expense_repository_impl.destroyExpense(id)
      expense

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Kategori dengan ID #{id} tidak ditemukan.")
    end
  end
end
