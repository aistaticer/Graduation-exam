class RankingController < ApplicationController
  def index

    @ranking_index = true;

    @recipes = Recipe.includes(:steps,:genre,:menu).with_attached_thumbnail.all
    delicious = StampsType.find_by(name: "Delicious")
    like = StampsType.find_by(name: "Like")
		StampMiddle.count_stamp_recipe(@recipes,delicious,like)
    StampMiddle.stamped_by_user?(@recipes,current_user.id,delicious,like)
    @sorted_recipes = @recipes.sort_by { |recipe| -recipe.likes_count }.first(10)
    @delicious_sorted_recipes = @recipes.sort_by { |recipe| -recipe.delicious_count }.first(10)
  
  end
end