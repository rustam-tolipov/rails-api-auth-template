class RefreshToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  before_validation :generate_token, on: :create

  # check if token is still active (not revoked and not expired)
  def active?
    !revoked && expires_at > Time.current
  end

  # revoke this token
  def revoke!
    update!(revoked: true)
  end

  # generate a secure random token
  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
    self.expires_at ||= 7.days.from_now
  end

  # cleanup expired or old revoked tokens (run via scheduled job)
  # deletes tokens that are either expired OR (revoked AND old)
  def self.cleanup_old_tokens
    where("expires_at < ? OR (revoked = ? AND created_at < ?)", 30.days.ago, true, 30.days.ago).delete_all
  end
end
