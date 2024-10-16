require_relative '../../domain/repositories/users_repository'

class UsersRepositoryImpl < UsersRepository
  def findAll
    user = User.all
    user
  end

  def findById(id)
    user = User.find(id)
    user
  end

  def create(attributes)
    newUser = User.create!(
      name: attributes[:name],
      email: attributes[:email],
    )
    newUser
  end

  def update(id, attributes)
    user = User.find(id)
    user.update!(
      name: attributes[:name],
      email: attributes[:email],
    )
    user
  end

  def destroy(id)
    User.find(id).destroy!
  end
end
