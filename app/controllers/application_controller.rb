class ApplicationController < ActionController::Base
	def custom_authenticate_user!
    Rails.logger.info("ああああああああauthenticate_user!")
    if !user_signed_in? && request.path != new_user_registration_path
      redirect_to new_user_registration_path
    end
  end

  def after_sign_in_path_for(resource)
    Rails.logger.debug "after_sign_in_path_for is called"
    recipes_path # これが'/recipes'へのパスを返す
  end

  def after_sign_up_path_for(resource)
    Rails.logger.debug "after_sign_up_path_for is called"
    recipes_path # これが'/recipes'へのパスを返す
  end

  def after_sign_out_path_for(resource)
    Rails.logger.debug "after_sign_up_path_for is called"
    new_user_session_path
  end

end
