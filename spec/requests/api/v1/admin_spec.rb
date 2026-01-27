require "swagger_helper"

RSpec.describe "api/v1/admin", type: :request do
  path "/api/v1/admin/dashboard" do
    get "admin dashboard (admin only)" do
      tags "Admin"
      produces "application/json"
      security [ bearer_auth: [] ]

      response "200", "admin dashboard accessed" do
        let!(:admin_user) { User.create!(email: "admin@example.com", password: "123456", password_confirmation: "123456", role: :admin) }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: admin_user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to include("Welcome to admin dashboard")
          expect(data["stats"]).to be_present
          expect(data["stats"]["total_users"]).to be_a(Integer)
        end
      end

      response "403", "forbidden for non-admin users" do
        let!(:regular_user) { User.create!(email: "user@example.com", password: "123456", password_confirmation: "123456", role: :user) }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: regular_user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["error"]).to include("Forbidden")
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
end
