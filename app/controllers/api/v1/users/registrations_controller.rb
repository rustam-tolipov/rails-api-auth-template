module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        # POST /api/v1/signup
        def create
          build_resource(sign_up_params)

          if resource.save
            render json: {
              message: 'Signed up successfully.',
              user: resource
            }, status: :created
          else
            render json: {
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        # strong params for signup
        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
