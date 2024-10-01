class UserPermissionsController < ApplicationController
  before_action :authenticate_user!

  def toggle
    user = User.find(params[:id])
    user.update(permissions: !user.permissions)
    redirect_back(fallback_location: root_path, notice: "Permissions updated.")
  end
end
