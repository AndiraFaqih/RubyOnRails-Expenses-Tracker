require_relative "../../infrastructure/db/user_repository_impl"

class UsersUsecase
  def initialize(user_repository = UsersRepositoryImpl.new)
    @user_repository_impl = user_repository
  end

  # Retrieves all users.
  # @return [ActiveRecord::Relation] a collection of all users
  def find_all
    begin
      users = @user_repository_impl.find_all
      users

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Users not found")
    end
  end

  # Finds a user by their ID.
  # @param id [Integer] the ID of the user to find
  # @return [User] the user object if found
  def find_by_id(id)
    begin
      user = @user_repository_impl.find_by_id(id)
      user

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("User not found")
    end
  end

  # Creates a new user with the given attributes.
  # @param attributes [Hash] the attributes for the new user
  # @return [User] the created user object
  def create(attributes)
    begin
      user = @user_repository_impl.create(attributes)
      user

    rescue StandardError => e
      raise e
    end
  end

  # Updates an existing user identified by ID with the given attributes.
  # @param id [Integer] the ID of the user to update
  # @param attributes [Hash] the attributes to update
  # @return [User] the updated user object
  def update(id, attributes)
    begin
      user = @user_repository_impl.update(id, attributes)
      user

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("User not found")
    end
  end

  # Deletes a user identified by ID.
  # @param id [Integer] the ID of the user to delete
  def destroy(id)
    begin
      @user_repository_impl.destroy(id)

    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("User not found")
    end
  end
end
