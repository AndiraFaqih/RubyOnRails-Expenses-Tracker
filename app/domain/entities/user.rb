class User
  attr_accessor :id, :name, :email, :encrypted_password, :created_at, :updated_at, :reset_password_token, :reset_password_sent_at, :remember_created_at

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @email = attributes[:email]
    @encrypted_password = attributes[:encrypted_password]
    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
    @reset_password_token = attributes[:reset_password_token]
    @reset_password_sent_at = attributes[:reset_password_sent_at]
    @remember_created_at = attributes[:remember_created_at]
  end
end
