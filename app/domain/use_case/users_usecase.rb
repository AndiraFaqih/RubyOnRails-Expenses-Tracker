require_relative "../../infrastructure/db/user_repository_impl"

class UsersUsecase
  def initialize(user_repository = UsersRepositoryImpl.new)
    @user_repository_impl = user_repository
  end

  def findAll
    @user_repository_impl.findAll
  end

  def findById(id)
    user = @user_repository_impl.findById(id)
    raise StandardError.new("User not found") unless user
    user
  end

  def create(attributes)
    @user_repository_impl.create(attributes)
  end

  def update(id, attributes)
    user = @user_repository_impl.update(id, attributes)
    user
  end

  def destroy(id)
    user = findById(id)
    raise StandardError.new("User not found") unless user
    @user_repository_impl.destroy(id)
  end
end
