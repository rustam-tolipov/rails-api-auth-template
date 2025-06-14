require "swagger_helper"

RSpec.describe "api/v1/signup", type: :request do
  path "/api/v1/signup" do
    post "registers a new user and returns a jwt" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"
      security []

      parameter name: :user, in: :body, schema: {
        type: :object,
        required: %w[email password password_confirmation],
        properties: {
          email: { type: :string, example: "newbob@example.com" },
          password: { type: :string, example: "123456" },
          password_confirmation: { type: :string, example: "123456" }
        }
      }

      response "201", "user created and token returned" do
        let(:user) do
          {
            email: "newbob@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        end
        run_test!
      end

      response "422", "validation failed invalid email + password" do
        let(:user) do
          {
            email: "",
            password: "123456",
            password_confirmation: "000000"
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to include(
            "Email can't be blank",
            "Password confirmation doesn't match Password"
          )
        end
      end
    end
  end
end
