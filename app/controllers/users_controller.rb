class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, only: [:make_admin, :make_permitted, :revoke_permissions]

  def index
    @users = User.all
  end

  def make_admin
    user = User.find(params[:id])
    user.update(role: 'admin') unless user == current_user
    redirect_to users_path
  end

  def make_permitted
    user = User.find(params[:id])
    user.update(role: 'permitted')
    redirect_to users_path
  end

  def revoke_permissions
    user = User.find(params[:id])
    user.update(role: 'user')
    redirect_to users_path
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, alert: "Only admins can perform this action."
    end
  end
end
