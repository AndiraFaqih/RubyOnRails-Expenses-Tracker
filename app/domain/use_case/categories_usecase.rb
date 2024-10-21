require_relative "../../infrastructure/db/categories_repository_impl"

class CategoriesUsecase
  def initialize(category_repository = CategoriesRepositoryImpl.new)
    @category_repository = category_repository
  end

  # Create a new category with the given attributes
  def create_category(attributes)
    begin
      user_id = attributes[:user_id]
      # Check if a category with the same name already exists
      existing_category = @category_repository.find_by_name(user_id, attributes[:name])

      if existing_category
        raise StandardError.new("Category with the name '#{attributes[:name]}' already exists.")
      elsif attributes[:name].empty? || attributes[:description].empty?
        raise StandardError.new("Category name and description cannot be empty.")
      else
        # If the category does not exist, create a new category
        category = @category_repository.create_category(attributes)
        category
      end
    rescue StandardError => e
      raise e # Re-raise the same error
    end
  end

  # Retrieve all categories for a given user
  def get_categories(user_id)
    begin
      categories = @category_repository.find_all_categories(user_id)

      if categories.empty?
        { message: "No categories found." }
      else
        categories
      end
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Categories not found.")
    end
  end

  # Retrieve a category by its ID
  def get_category_by_id(id)
    begin
      category = @category_repository.find_category_by_id(id)
      category # Return the category if found
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Category with ID #{id} not found.")
    end
  end

  # Retrieve a category by its name
  def get_category_by_name(name, user_id)
    begin
      category = @category_repository.find_by_name(user_id, name)
      category # Return the category if found
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Category with the name '#{name}' not found.")
    end
  end

  # Update an existing category's attributes
  def update_category(id, attributes)
    begin
      attributes_to_update = {}
      attributes_to_update[:name] = attributes[:name] if attributes[:name].present?
      attributes_to_update[:description] = attributes[:description] if attributes[:description].present?

      @category_repository.update_category(id, attributes_to_update)
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Category with ID #{id} not found.")
    end
  end

  # Delete a category by its ID
  def delete_category(id)
    begin
      @category_repository.find_category_by_id(id)
      @category_repository.destroy_category(id) # Delete the category if found
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Category with ID #{id} not found.")
    end
  end
end
