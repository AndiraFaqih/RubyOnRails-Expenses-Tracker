# Abstract base class for Category repository
class CategoriesRepository
  # Retrieve all categories
  def find_all_categories
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Find a category by its ID
  def find_category_by_id(id)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Create a new category with the given attributes
  def create_category(attributes)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Update an existing category identified by its ID
  def update_category(id, attributes)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end

  # Delete a category identified by its ID
  def destroy_category(id)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end
end
