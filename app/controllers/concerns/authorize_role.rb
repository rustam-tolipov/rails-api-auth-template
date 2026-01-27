# this concern provides role-based authorization
# usage: add `before_action :require_admin` in controllers that need admin access
# or use `authorize_role!(:admin, :moderator)` to check multiple roles

module AuthorizeRole
  extend ActiveSupport::Concern

  private

  # check if current user has any of the specified roles
  def authorize_role!(*roles)
    unless @current_user && roles.map(&:to_s).include?(@current_user.role)
      render json: { error: "Forbidden: insufficient permissions" }, status: :forbidden
    end
  end

  # helper methods for specific roles
  def require_admin
    authorize_role!(:admin)
  end

  def require_moderator
    authorize_role!(:admin, :moderator)
  end

  def require_user
    authorize_role!(:user, :moderator, :admin)
  end
end
