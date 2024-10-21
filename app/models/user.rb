# class RevokedToken < ApplicationRecord
#   # Model yang menyimpan JWT yang telah di-revoke
#   belongs_to :user
# end

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :validatable, :jwt_authenticatable, 
         jwt_revocation_strategy: self

  has_many :expenses
  has_many :categories

  # def self.jwt_revoked?(payload, user)
  #   jti = payload['jti'] # JWT ID untuk identifikasi unik setiap token
  #   RevokedToken.exists?(jti: jti)
  # end

  # def self.revoke_jwt(payload, user)
  #   jti = payload['jti']
  #   RevokedToken.create!(user: user, jti: jti) # Simpan token yang di-revoke
  # end
end
