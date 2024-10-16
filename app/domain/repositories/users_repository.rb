class UsersRepository
  def findAll
    raise NotImplementedError
  end

  def findById(id)
    raise NotImplementedError
  end

  def create(attributes)
    raise NotImplementedError
  end

  def update(id, attributes)
    raise NotImplementedError
  end

  def destroy(id)
    raise NotImplementedError
  end
end
