module Api
  module V1
    class AuthController < ApplicationController
      # post /signup → signup user and return jwt
      # I used strong params so no sql injection here (rails got your back)
      def signup
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token:, user: user.as_json(only: %i[id email]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # post /login → login with email & password (keep it simple)
      # if it matches, it give you a token. if not, try again buddy
      def login
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token:, user: user.as_json(only: %i[id email]) }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      # only allow what we actually need. nothing fancy, nothing extra. not need for require
      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
