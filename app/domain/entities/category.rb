class Category
  attr_accessor :id, :name, :description, :user_id, :created_at, :updated_at

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @description = attributes[:description]
    @user_id = attributes[:user_id]
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end
end
