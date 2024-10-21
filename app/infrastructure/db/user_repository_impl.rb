require_relative '../../domain/repositories/users_repository'

class UsersRepositoryImpl < UsersRepository
  # Retrieves all users from the database.
  def find_all
    User.all
  end

  # Finds a user by their ID.
  def find_by_id(id)
    User.find(id)
  end

  # Creates a new user with the given attributes.
  def create(attributes)
    User.create!(attributes)
  end

  # Updates an existing user identified by ID with the given attributes.
  def update(id, attributes)
    user = User.find(id)
    user.update!(attributes)
    user
  end

  # Deletes a user identified by ID.
  def destroy(id)
    User.find(id).destroy!
  end
end
