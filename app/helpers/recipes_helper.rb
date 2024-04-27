module RecipesHelper
  def copy_recipe_helper(recipe)
    original_recipe = Recipe.includes(:steps,:categories,:ingredients).find(recipe.id)
    copied_recipe = original_recipe.dup
    copied_recipe.name += "（コピー）"

    # レシピは保存せずに、ステップも複製して保存せずに配列に保持する
    copied_recipe_steps = original_recipe.steps.map do |step|
      copied_step = step.dup
      copied_step.recipe = copied_recipe #これで関連付けるだけで、IDはまだ設定しない
      copied_step
    end

    copied_recipe_categories = original_recipe.categories

    copied_recipe_ingredients = original_recipe.ingredients.map do |ingredient|
      copied_ingredient = ingredient.dup
      copied_ingredient.recipe = copied_recipe #これで関連付けるだけで、IDはまだ設定しない
      copied_ingredient
    end

    # ここでは保存せずに、複製したレシピオブジェクトを返す
    return copied_recipe, copied_recipe_steps, copied_recipe_categories, copied_recipe_ingredients
  end
end
