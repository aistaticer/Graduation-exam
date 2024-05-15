class UsersController < ApplicationController
  def show
    @url_user_show = true;
    @user = User.includes(:recipes).find(params[:id])
    StampMiddle.count_like_recipe(@user.recipes)
  end
end