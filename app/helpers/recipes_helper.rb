module RecipesHelper
  def copy_recipe_helper(recipe)
    original_recipe = Recipe.includes(:steps,:categories).find(recipe.id)
    copied_recipe = original_recipe.dup
    copied_recipe.name += "（コピー）"

    # レシピは保存せずに、ステップも複製して保存せずに配列に保持する
    copied_recipe_steps = original_recipe.steps.map do |step|
      copied_step = step.dup
      copied_step.recipe = copied_recipe #これで関連付けるだけで、IDはまだ設定しない
      copied_step
    end

    # ここでは保存せずに、複製したレシピオブジェクトを返す
    return copied_recipe, copied_recipe_steps
  end
end
