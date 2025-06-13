require "swagger_helper"

RSpec.describe "api/v1/auth", type: :request do
  path "/api/v1/login" do
    post "logs in a user" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"
      security []
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        required: %w[email password],
        properties: {
          email: {
            type: :string,
            example: "bob@random.com"
          },
          password: {
            type: :string,
            example: "123456"
          }
        }
      }

      response "200", "logged in" do
        let!(:user) { User.create(email: "bob@random.com", password: "123456", password_confirmation: "123456") }
        let(:credentials) { { email: "bob@random.com", password: "123456" } }
        run_test!
      end

      response "401", "invalid credentials" do
        let(:credentials) { { email: "notbob@example.com", password: "wrong" } }
        run_test!
      end
    end
  end
end
