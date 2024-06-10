# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :custom_authenticate_user!


  def new
    @url_sign_in = true
    super
  end

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end
  
  def edit
    @url_user_edit = true;
  end

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
