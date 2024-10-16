require_relative "../../domain/repositories/categories_repository"

class CategoriesRepositoryImpl < CategoriesRepository
  def findAllCategories(user_id)
    categories = Category.where(user_id: user_id)
    categories
  end

  def findCategoryById(id)
    category = Category.find(id)
    category
  end

  def createCategory(attributes)
    categories = Category.create!(attributes)
    categories
  end

  def updateCategory(id, attributes)
    category = Category.find(id)
    category.update!(attributes)
    category
  end

  def destroyCategory(id)
    category = Category.find(id)
    category.destroy!
  end

  def find_by_name(name)
    Category.find_by(name: name)
  end
end
