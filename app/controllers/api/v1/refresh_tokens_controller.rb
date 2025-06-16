module Api
  module V1
    class RefreshTokensController < ApplicationController
      def create
        refresh_token = params[:refresh_token]

        token_record = RefreshToken.find_by(token: refresh_token, revoked: false)

        if token_record && token_record.expires_at > Time.current
          user = token_record.user

          jwt = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
          new_token = jwt[0]

          render json: { access_token: new_token }, status: :ok
        else
          render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
        end
      end
    end
  end
end
