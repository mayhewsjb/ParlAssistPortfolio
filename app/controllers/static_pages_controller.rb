class StaticPagesController < ApplicationController
  skip_before_action :check_permissions, only: [:permissions]

  def permissions
    # This method will render the corresponding view
  end
end
