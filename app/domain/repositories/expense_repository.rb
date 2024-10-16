class ExpenseRepository
  def create(attributes)
    raise NotImplementedError
  end

  def findExpenseById(id)
    raise NotImplementedError
  end

  def findAllExpenses(userId)
    raise NotImplementedError
  end

  def updateExpense(id, attributes)
    raise NotImplementedError
  end

  def deleteExpense(id)
    raise NotImplementedError
  end
end
