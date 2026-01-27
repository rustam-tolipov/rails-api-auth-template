class BlacklistedToken < ApplicationRecord
  belongs_to :user

  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true

  # check if a token is blacklisted
  def self.blacklisted?(jti)
    exists?(jti: jti)
  end

  # cleanup expired tokens (run this via a scheduled job)
  def self.cleanup_expired
    where("exp < ?", Time.current).delete_all
  end
end
