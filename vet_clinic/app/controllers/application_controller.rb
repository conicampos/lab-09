class ApplicationController < ActionController::Base
  # 1. Exigir login en toda la aplicación por defecto
  before_action :authenticate_user!
  
  # 2. Configurar campos permitidos para Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end