class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # 1. Exigir login en toda la aplicación por defecto
  before_action :authenticate_user!
  after_action :verify_pundit_authorization, unless: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  # 2. Configurar campos permitidos para Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def verify_pundit_authorization
    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end
