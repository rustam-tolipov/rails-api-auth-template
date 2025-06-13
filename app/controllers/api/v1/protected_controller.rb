module Api
  module V1
    class ProtectedController < ApplicationController
      include AuthorizeRequest

      def index
        render json: {
          message: "you are free to use this buddy",
          user: @current_user.as_json(only: %(id email))
        }
      end
    end
  end
end
