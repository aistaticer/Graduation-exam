class UsersController < ApplicationController
  def show
    @url_user_show = true;
    @user = User.includes(:recipes).find(params[:id])

  end
end