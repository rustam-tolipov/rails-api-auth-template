require "rails_helper"

RSpec.describe BlacklistedToken, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "123456", password_confirmation: "123456") }

  describe "validations" do
    it "requires jti" do
      token = BlacklistedToken.new(user: user, exp: 1.hour.from_now)
      expect(token.valid?).to be false
      expect(token.errors[:jti]).to include("can't be blank")
    end

    it "requires exp" do
      token = BlacklistedToken.new(user: user, jti: SecureRandom.uuid)
      expect(token.valid?).to be false
      expect(token.errors[:exp]).to include("can't be blank")
    end

    it "requires unique jti" do
      jti = SecureRandom.uuid
      BlacklistedToken.create!(user: user, jti: jti, exp: 1.hour.from_now)

      duplicate = BlacklistedToken.new(user: user, jti: jti, exp: 1.hour.from_now)
      expect(duplicate.valid?).to be false
      expect(duplicate.errors[:jti]).to include("has already been taken")
    end
  end

  describe ".blacklisted?" do
    it "returns true for blacklisted tokens" do
      jti = SecureRandom.uuid
      BlacklistedToken.create!(user: user, jti: jti, exp: 1.hour.from_now)

      expect(BlacklistedToken.blacklisted?(jti)).to be true
    end

    it "returns false for non-blacklisted tokens" do
      expect(BlacklistedToken.blacklisted?("non-existent-jti")).to be false
    end
  end

  describe ".cleanup_expired" do
    it "removes expired tokens" do
      expired_token = BlacklistedToken.create!(user: user, jti: SecureRandom.uuid, exp: 1.day.ago)
      valid_token = BlacklistedToken.create!(user: user, jti: SecureRandom.uuid, exp: 1.hour.from_now)

      expect {
        BlacklistedToken.cleanup_expired
      }.to change { BlacklistedToken.count }.by(-1)

      expect(BlacklistedToken.exists?(expired_token.id)).to be false
      expect(BlacklistedToken.exists?(valid_token.id)).to be true
    end
  end
end
