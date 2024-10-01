class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_permissions, unless: :devise_controller_actions?

  protected

  def check_permissions
    if user_signed_in?
      redirect_to permissions_path, alert: "You do not have permission to access this site." unless current_user.permitted? || current_user.admin?
    end
  end

  def devise_controller_actions?
    # Check if the current controller is a Devise controller and the action is 'destroy'
    devise_controller? && action_name == 'destroy'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
