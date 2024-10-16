class CategoriesRepository
  def findAllCategories
    raise NotImplementedError
  end

  def findCategoryById(id)
    raise NotImplementedError
  end

  def createCategory(attributes)
    raise NotImplementedError
  end

  def updateCategory(id, attributes)
    raise NotImplementedError
  end

  def destroyCategory(id)
    raise NotImplementedError
  end
end