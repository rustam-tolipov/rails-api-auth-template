require "rails_helper"

RSpec.describe "Rack::Attack throttling", type: :request do
  describe "POST /api/v1/login" do
    let!(:user) do
      User.create(email: "bob@random.com", password: "123456", password_confirmation: "123456")
    end

    it "throttles after 3 login attempts" do
      3.times do
        post "/api/v1/login", params: {
          email: "bob@random.com",
          password: "wrongpassword"
        }.to_json, headers: { "CONTENT_TYPE" => "application/json" }

        expect(response.status).to_not eq(429)
      end

      # this one is going to be blocked. too much attempt
      post "/api/v1/login", params: {
        email: "bob@random.com",
        password: "wrongpassword"
      }.to_json, headers: { "CONTENT_TYPE" => "application/json" }

      expect(response.status).to eq(429)
      expect(response.body).to include("chill out")
    end
  end
end
