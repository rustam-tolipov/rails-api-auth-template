module Api
  module V1
    class AuthController < ApplicationController
      include AuthorizeRequest
      skip_before_action :authorize_request, only: %i[signup login refresh]

      # post /signup -> signup user and return jwt + refresh token
      # I used strong params so no sql injection here (rails got your back)
      def signup
        user = User.new(user_params)
        if user.save
          tokens = generate_tokens(user)
          render json: { **tokens, user: user.as_json(only: %i[id email role]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # post /login -> login with email & password (keep it simple)
      # if it matches, it gives you both access token and refresh token
      def login
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          tokens = generate_tokens(user)
          render json: { **tokens, user: user.as_json(only: %i[id email role]) }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # post /refresh -> exchange refresh token for new access token
      # keeps users logged in without re-entering credentials
      def refresh
        refresh_token = RefreshToken.find_by(token: params[:refresh_token])

        if refresh_token&.active?
          user = refresh_token.user
          access_token = JsonWebToken.encode(user_id: user.id)
          render json: { access_token:, user: user.as_json(only: %i[id email role]) }, status: :ok
        else
          render json: { error: "Invalid or expired refresh token" }, status: :unauthorized
        end
      end

      # post /logout -> NOW with real token blacklisting
      # adds the current token to blacklist so it can't be used again
      # authorize_request ensures @current_user and token are present
      def logout
        header = request.headers["Authorization"]
        token = header.split(" ").last if header

        decoded = JsonWebToken.decode(token)
        BlacklistedToken.create!(
          jti: decoded[:jti],
          user_id: decoded[:user_id],
          exp: Time.at(decoded[:exp])
        )

        # also revoke all refresh tokens for this user
        @current_user.refresh_tokens.update_all(revoked: true)

        render json: { message: "Successfully logged out. Token blacklisted." }, status: :ok
      rescue StandardError => e
        render json: { error: "Logout failed: #{e.message}" }, status: :unprocessable_entity
      end

      private

      # only allow what we actually need. nothing fancy, nothing extra. not need for require
      def user_params
        params.permit(:email, :password, :password_confirmation)
      end

      # generate both access and refresh tokens
      def generate_tokens(user)
        access_token = JsonWebToken.encode(user_id: user.id)
        refresh_token = user.refresh_tokens.create!

        {
          access_token: access_token,
          refresh_token: refresh_token.token,
          expires_in: 1.hour.to_i
        }
      end
    end
  end
end
