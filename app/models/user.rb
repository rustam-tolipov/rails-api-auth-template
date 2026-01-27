class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :rememberable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  # associations
  has_many :blacklisted_tokens, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy

  # role-based authorization
  enum :role, { user: 0, admin: 1, moderator: 2 }

  # validations so your db doesn't turn into a trash can
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
