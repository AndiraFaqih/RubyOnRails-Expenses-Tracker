require_relative "../../infrastructure/db/expense_repository_impl"

class ExpenseUsecase
  def initialize(expense_repository = ExpenseRepositoryImpl.new)
    @expense_repository_impl = expense_repository
  end

  # Find all expenses for a given user
  def find_all_expenses(user_id)
    begin
      @expense_repository_impl.find_all_expenses(user_id)
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expenses not found.")
    end
  end

  # Find an expense by its ID
  def find_expense_by_id(expense_id)
    begin
      expense = @expense_repository_impl.find_expense_by_id(expense_id)
      return nil unless expense
      expense
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expense with ID #{expense_id} not found.")
    end
  end

  # Create a new expense
  def create_expense(attributes)
    exclude_attributes = attributes.except(:category_name)
    begin
      @expense_repository_impl.create_expense(exclude_attributes)
    rescue StandardError => e
      raise e
    end
  end

  # Update an existing expense
  def update_expense(id, attributes)
    begin
      attributes_to_update = {}
      attributes_to_update[:amount] = attributes[:amount] if attributes[:amount].present?
      attributes_to_update[:description] = attributes[:description] if attributes[:description].present?

      @expense_repository_impl.update_expense(id, attributes_to_update)
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expense with ID #{id} not found.")
    end
  end

  # Delete an expense
  def destroy_expense(id)
    begin
      find_expense_by_id(id) # Check if expense exists
      @expense_repository_impl.destroy_expense(id)
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expense with ID #{id} not found.")
    end
  end

  # Calculate total expenses for a given month and year
  def expense_month_total(user_id, month, year)
    begin
      @expense_repository_impl.expense_month_total(user_id, month, year)
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expenses not found.")
    end
  end

  # Calculate total expenses for a given year by month
  def expense_year_total(user_id, month, year)
    begin
      monthly_expense = {}
      total_year_expense = 0

      (1..month).each do |m|
        month_name = Date::MONTHNAMES[m]
        monthly_expense[month_name] = expense_month_total(user_id, m, year)
        total_year_expense += monthly_expense[month_name]
      end

      {
        monthly_expense: monthly_expense,
        total_year_expense: total_year_expense
      }
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Expenses not found.")
    end
  end
end
