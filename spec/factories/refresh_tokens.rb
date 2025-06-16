FactoryBot.define do
  factory :refresh_token do
    user { nil }
    token { "MyString" }
    expires_at { "2025-06-16 06:02:34" }
    revoked { false }
  end
end
