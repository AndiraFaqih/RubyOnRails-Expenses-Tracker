class UsersRepository
  # Retrieves all users.
  def find_all
    raise NotImplementedError
  end

  # Finds a user by their ID.
  def find_by_id(id)
    raise NotImplementedError
  end

  # Creates a new user with the given attributes.
  def create(attributes)
    raise NotImplementedError
  end

  # Updates an existing user identified by ID with the given attributes.
  def update(id, attributes)
    raise NotImplementedError
  end

  # Deletes a user identified by ID.
  def destroy(id)
    raise NotImplementedError
  end
end
