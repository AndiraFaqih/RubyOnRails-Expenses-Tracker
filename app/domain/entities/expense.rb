class Expense
  attr_accessor :id, :amount, :description, :user_id, :category_id, :created_at, :updated_at

  def initialize(attributes = {})
    @id = attributes[:id]
    @amount = attributes[:amount]
    @description = attributes[:description]
    @user_id = attributes[:user_id]
    @category_id = attributes[:category_id]
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end
end
