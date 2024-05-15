# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :custom_authenticate_user!

  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar, :bio])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :bio])
  end

  def update_resource(resource, params)
    if params[:avatar].blank?
      params[:avatar] = nil
    end
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    user_path(current_user)  # ここを任意のパスに変更する
  end

  private

  def account_update_params
    params.require(:user).permit(:name, :email, :bio, :avatar)
  end
end
