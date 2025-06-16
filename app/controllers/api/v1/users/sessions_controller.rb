module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        # Override Devise's create
        def create
          user = User.find_by(email: params.dig(:user, :email))

          if user&.valid_password?(params.dig(:user, :password))

            refresh_token = user.refresh_tokens.create!(
              token: SecureRandom.hex(64),
              expires_at: 30.days.from_now,
              revoked: false
            )

            jwt = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
            access_token = jwt[0]

            render json: {
              message: 'Logged in successfully.',
              user: user,
              refresh_token: refresh_token.token,
              access_token: access_token
            }, status: :ok
          else
            render json: { message: 'Invalid email or password' }, status: :unauthorized
          end
        end

        # DELETE /api/v1/logout
        def respond_to_on_destroy
          if current_user
            render json: { message: 'Logged out successfully.' }, status: :ok
          else
            render json: { message: 'Logout failed.' }, status: :unauthorized
          end
        end
      end
    end
  end
end
