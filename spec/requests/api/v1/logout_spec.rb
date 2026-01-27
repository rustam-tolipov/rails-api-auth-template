require "swagger_helper"

RSpec.describe "api/v1/logout", type: :request do
  path "/api/v1/logout" do
    post "logs out user and blacklists token" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"
      security [ bearer_auth: [] ]

      let!(:user) { User.create!(email: "test@example.com", password: "123456", password_confirmation: "123456") }

      response "200", "successfully logged out" do
        let(:Authorization) do
          token = JsonWebToken.encode(user_id: user.id)
          "Bearer #{token}"
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to include("Successfully logged out")

          # verify token was blacklisted by checking the response
          # (we can't decode the token variable here as it's scoped to the let block)
        end
      end

      response "401", "unauthorized without token" do
        let(:Authorization) { "" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to include("unauthorized")
        end
      end
    end
  end

  describe "blacklisted token rejection" do
    it "rejects requests with blacklisted tokens" do
      user = User.create!(email: "test@example.com", password: "123456", password_confirmation: "123456")
      token = JsonWebToken.encode(user_id: user.id)

      # first logout to blacklist the token
      post "/api/v1/logout", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)

      # try to access protected endpoint with blacklisted token
      get "/api/v1/profile", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unauthorized)
      data = JSON.parse(response.body)
      expect(data["error"]).to include("Token has been revoked")
    end
  end
end
