class ApplicationController < ActionController::Base
  #before_action :log_flash_messages

	def custom_authenticate_user!
    if !user_signed_in? && request.path != new_user_registration_path
      redirect_to new_user_registration_path
    end
  end

  def after_sign_in_path_for(resource)

    recipes_path # これが'/recipes'へのパスを返す
  end

  def after_sign_up_path_for(resource)
    
    recipes_path # これが'/recipes'へのパスを返す
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def some_action
    # renderされたかどうかを確認
    if performed?
      # renderされた場合の処理
      puts "Rendered"
    else
      # redirect_toされた場合の処理
      puts "Redirected"
    end
  end

  def log_flash_messages
    flash.each do |key, message|
      Rails.logger.info "Flash message - #{key}: #{message}"
    end
  end

end
