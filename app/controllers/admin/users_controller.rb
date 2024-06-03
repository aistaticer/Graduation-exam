class Admin::UsersController < ApplicationController
	def index
		@users = User.with_attached_avatar.all
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		redirect_to admin_users_path, notice: 'ユーザーが削除されました。'
	end
end
