# this concern checks the token and finds the user
# if token is invalid or missing, we block the request
# usage: just add `before_action :authorize_request` in any controller you wanna protect
# I keep things simple, if you want to make it better it's you choice

module AuthorizeRequest
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, StandardError => e
      render json: { error: "unauthorized: #{e.message}" }, status: :unauthorized
    end
  end
end
