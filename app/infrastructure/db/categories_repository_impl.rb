require_relative "../../domain/repositories/categories_repository"

class CategoriesRepositoryImpl < CategoriesRepository
  # Retrieve all categories for a given user
  def find_all_categories(user_id)
    Category.where(user_id: user_id)
  end

  # Find a category by its ID
  def find_category_by_id(id)
    Category.find(id)
  end

  # Create a new category with the given attributes
  def create_category(attributes)
    Category.create!(attributes) # Raises an exception if creation fails
  end

  # Update an existing category identified by its ID
  def update_category(id, attributes)
    category = find_category_by_id(id)
    category.update!(attributes) # Raises an exception if update fails
    category
  end

  # Delete a category identified by its ID
  def destroy_category(id)
    category = find_category_by_id(id)
    category.destroy! # Raises an exception if deletion fails
  end

  # Find a category by its name
  def find_by_name(user_id, name)
    Category.where(user_id: user_id).find_by(name: name)
  end
end
