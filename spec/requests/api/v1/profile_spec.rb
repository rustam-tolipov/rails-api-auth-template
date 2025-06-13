require "swagger_helper"

RSpec.describe "api/v1/profile", type: :request do
  path "/api/v1/profile" do
    get "get current user info using jwt token" do
      tags "Profile"
      security [ bearer_auth: [] ]
      produces "application/json"

      response "200", "profile fetched" do
        let!(:user) { User.create(email: "bob@random.com", password: "123456", password_confirmation: "123456") }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

        run_test!
      end

      response "401", "unauthorized access" do
        let(:Authorization) { "" }
        run_test!
      end
    end
  end
end
