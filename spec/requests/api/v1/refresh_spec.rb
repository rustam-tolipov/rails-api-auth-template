require "swagger_helper"

RSpec.describe "api/v1/refresh", type: :request do
  path "/api/v1/refresh" do
    post "refreshes access token using refresh token" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"
      security []

      parameter name: :refresh_request, in: :body, schema: {
        type: :object,
        required: %w[refresh_token],
        properties: {
          refresh_token: { type: :string, example: "your_refresh_token_here" }
        }
      }

      let(:user) { User.create!(email: "test@example.com", password: "123456", password_confirmation: "123456") }
      let(:refresh_token_record) { user.refresh_tokens.create! }

      response "200", "new access token issued" do
        let(:refresh_request) { { refresh_token: refresh_token_record.token } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["access_token"]).to be_present
          expect(data["user"]["email"]).to eq("test@example.com")
        end
      end

      response "401", "invalid or expired refresh token" do
        let(:refresh_request) { { refresh_token: "invalid_token" } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to include("Invalid or expired refresh token")
        end
      end

      response "401", "revoked refresh token" do
        before do
          refresh_token_record.revoke!
        end

        let(:refresh_request) { { refresh_token: refresh_token_record.token } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to include("Invalid or expired refresh token")
        end
      end
    end
  end
end
