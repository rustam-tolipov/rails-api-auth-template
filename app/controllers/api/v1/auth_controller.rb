module Api
  module V1
    class AuthController < ApplicationController
      # POST /signup
      # signs up the user and returns a JWT. nothing fancy, just honest JSON.
      # bonus: no SQL injection here —> thanks, ActiveRecord 💪
      def signup
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token:, user: user.as_json(only: %i[id email]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /login
      # authenticates the user by email and password. if correct, we send you a shiny JWT.
      # if not -> sorry, no tokens for you 🙅‍♂️
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

      # only permit what we need. No surprises. No mass assignment circus.
      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
