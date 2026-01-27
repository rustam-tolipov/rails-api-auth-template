require "rails_helper"

RSpec.describe RefreshToken, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "123456", password_confirmation: "123456") }

  describe "validations" do
    it "generates token automatically" do
      token = RefreshToken.create!(user: user)
      expect(token.token).to be_present
    end

    it "sets expiration automatically" do
      token = RefreshToken.create!(user: user)
      expect(token.expires_at).to be_present
      expect(token.expires_at).to be > Time.current
    end

    it "requires unique token" do
      token1 = RefreshToken.create!(user: user)
      token2 = RefreshToken.new(user: user, token: token1.token, expires_at: 7.days.from_now)

      expect(token2.valid?).to be false
      expect(token2.errors[:token]).to include("has already been taken")
    end
  end

  describe "#active?" do
    it "returns true for non-revoked, non-expired tokens" do
      token = RefreshToken.create!(user: user)
      expect(token.active?).to be true
    end

    it "returns false for revoked tokens" do
      token = RefreshToken.create!(user: user, revoked: true)
      expect(token.active?).to be false
    end

    it "returns false for expired tokens" do
      token = RefreshToken.create!(user: user, expires_at: 1.day.ago)
      expect(token.active?).to be false
    end
  end

  describe "#revoke!" do
    it "marks token as revoked" do
      token = RefreshToken.create!(user: user)
      expect(token.revoked).to be false

      token.revoke!
      expect(token.revoked).to be true
    end
  end

  describe ".cleanup_old_tokens" do
    it "removes expired and revoked tokens" do
      old_expired = RefreshToken.create!(user: user, expires_at: 31.days.ago)
      old_revoked = RefreshToken.create!(user: user, revoked: true, created_at: 31.days.ago, expires_at: 1.day.from_now)
      recent_revoked = RefreshToken.create!(user: user, revoked: true, expires_at: 1.day.from_now)
      valid_token = RefreshToken.create!(user: user)

      expect {
        RefreshToken.cleanup_old_tokens
      }.to change { RefreshToken.count }.by(-2)

      expect(RefreshToken.exists?(old_expired.id)).to be false
      expect(RefreshToken.exists?(old_revoked.id)).to be false
      expect(RefreshToken.exists?(recent_revoked.id)).to be true
      expect(RefreshToken.exists?(valid_token.id)).to be true
    end
  end
end
