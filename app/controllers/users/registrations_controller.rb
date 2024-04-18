# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_up_path_for(resource)
    Rails.logger.debug "after_sign_up_path_for is called"
    recipes_path # これが'/recipes'へのパスを返す
  end

  def after_sign_in_path_for(resource)
    Rails.logger.debug "after_sign_in_path_for is called"
    recipes_path # これが'/recipes'へのパスを返す
  end

  def configure_permitted_parameters
    Rails.logger.info("あああああああああああああああああ")
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # ログインページへのパス
  end
end
