FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-06-15 23:51:38" }
  end
end
