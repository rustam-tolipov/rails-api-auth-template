module Api
  module V1
    class ProfileController < ApplicationController
      include AuthorizeRequest

      # get /profile
      # this is for getting current user who logged in
      def show
        render json: {
          id: @current_user.id,
          email: @current_user.email
        }, status: :ok
      end
    end
  end
end
