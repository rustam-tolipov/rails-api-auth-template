class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
