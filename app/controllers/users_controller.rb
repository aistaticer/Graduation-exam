class UsersController < ApplicationController
  def show
    @url_user_show = true;
    @user = User.includes(:recipes).find(params[:id])

    delicious_type = StampsType.find_by(name: "Delicious")
    like_type = StampsType.find_by(name: "Like")
    StampMiddle.stamped_by_user?(@user.recipes,current_user.id,delicious_type,like_type)
    StampMiddle.count_stamp_recipe(@user.recipes,delicious_type,like_type)
  end
end