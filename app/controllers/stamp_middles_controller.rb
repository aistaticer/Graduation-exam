class StampMiddlesController < ApplicationController
  
  def create
    stamp
  end

  def destroy
    stamp_delete
  end

  private

  def page_load
    referrer_url = params[:referrer]
    if referrer_url == 'https://evolution-recipes-949263457034.herokuapp.com/ranking'
      redirect_to ranking_index_path
    end
  end

  def stamp
    @recipe = Recipe.find(params[:recipe_id])
    stamp_name = params[:stamp_type]
    stamp_type = StampsType.find_by(name: stamp_name)
    @stamp = StampMiddle.new(recipe_id: @recipe.id, user_id: current_user.id, stamps_type_id: stamp_type.id)
  
    if @stamp.save
      page_load and return
      
      if stamp_name == "Delicious"
        StampMiddle.count_stamp_recipe([@recipe], stamp_type, nil)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("unstamped_delicious_button_#{@recipe.id}", partial: 'shared/stamps/delicious_delete', locals: { recipe: @recipe, stamp_middle: @stamp.id}),
              turbo_stream.replace("delicious_count_#{@recipe.id}", partial: 'shared/stamps/delicious_count', locals: { recipe: @recipe})
            ]
          end
          format.html { redirect_to recipes_path }
        end
      end

      if stamp_name == "Like"
        StampMiddle.count_stamp_recipe([@recipe], nil, stamp_type)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("unliked_button_#{@recipe.id}", partial: 'shared/stamps/like_delete', locals: { recipe: @recipe, stamp_middle: @stamp.id}),
              turbo_stream.replace("like_count_#{@recipe.id}", partial: 'shared/stamps/like_count', locals: { recipe: @recipe})
            ]
          end
          format.html { redirect_to recipes_path }
        end
      end

    else
    end
  end

  def stamp_delete
    @stamp = StampMiddle.find(params[:id])
    @recipe = Recipe.find(params[:recipe_id])

    stamp_name = params[:stamp_type]
    stamp_type = StampsType.find_by(name: stamp_name)
    StampMiddle.count_stamp_recipe([@recipe], stamp_type, nil)

    if @stamp.destroy
      
      # ランキングの場合はレシピが重複する恐れがあるからリロードさせてる
      page_load and return

      case stamp_name
      when "Delicious"

        StampMiddle.count_stamp_recipe([@recipe], stamp_type, nil)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("stamped_delicious_button_#{@recipe.id}", partial: 'shared/stamps/delicious_create', locals: { recipe: @recipe, stamp_middle: @stamp.id}),
              turbo_stream.replace("delicious_count_#{@recipe.id}", partial: 'shared/stamps/delicious_count', locals: { recipe: @recipe})
            ]
          end
          format.html { redirect_to recipes_path }
        end
      
      when "Like"
        StampMiddle.count_stamp_recipe([@recipe], nil, stamp_type)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("liked_button_#{@recipe.id}", partial: 'shared/stamps/like_create', locals: { recipe: @recipe, stamp_middle: @stamp.id}),
              turbo_stream.replace("like_count_#{@recipe.id}", partial: 'shared/stamps/like_count', locals: { recipe: @recipe})
            ]
          end
          format.html { redirect_to recipes_path }
        end
      end

    end

  end
end
