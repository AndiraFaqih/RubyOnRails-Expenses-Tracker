# Abstract base class for Expense repository
class ExpenseRepository
  # Create a new expense with the given attributes
  def create(attributes)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Find an expense by its ID
  def find_expense_by_id(id)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Find all expenses for a given user
  def find_all_expenses(user_id)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Update an existing expense identified by its ID
  def update_expense(id, attributes)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Delete an expense identified by its ID
  def delete_expense(id)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Calculate total expenses for a given month and year
  def expense_month_total(user_id, month, year)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end
end
