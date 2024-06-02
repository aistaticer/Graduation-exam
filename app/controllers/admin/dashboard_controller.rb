module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
		before_action :check_admin

    def index
      # 管理画面のリンク一覧を表示するためのロジックをここに書く
    end

		private

		def check_admin
			redirect_to admin_dashboard_path unless current_user.admin?
		end
  end
end