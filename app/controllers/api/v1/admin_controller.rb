module Api
  module V1
    class AdminController < ApplicationController
      include AuthorizeRequest
      include AuthorizeRole

      before_action :require_admin

      # example admin-only endpoint
      # GET /api/v1/admin/dashboard
      def dashboard
        render json: {
          message: "Welcome to admin dashboard",
          stats: {
            total_users: User.count,
            total_admins: User.admin.count,
            total_moderators: User.moderator.count
          }
        }, status: :ok
      end
    end
  end
end
