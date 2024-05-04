# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :custom_authenticate_user!

  protected


  def configure_permitted_parameters
    Rails.logger.info("ああああああああconfigure_permitted_parameters")
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end
