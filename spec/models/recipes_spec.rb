require 'rails_helper'

RSpec.describe Recipe, type: :model do
  # 必須フィールドが全て存在するときは有効であること
  it 'is valid with a user_id, name, bio, thumbnail, copy_permission' do
    recipe = FactoryBot.build(:recipe)
    expect(recipe).to be_valid
  end
  
  # nameが25文字以内かつ存在するときは有効であること
  it 'is valid with a name that has less than or equal to 25 characters' do
    recipe = FactoryBot.build(:recipe, name: 'a' * 25)
    expect(recipe).to be_valid
  end
  
  # nameが25文字を超えるときは無効であること
  it 'is invalid with a name that has more than 25 characters' do
    recipe = FactoryBot.build(:recipe, name: 'a' * 26)
    expect(recipe).not_to be_valid
    expect(recipe.errors[:name]).to include("レシピ名は25文字以内で入力してください")
  end
  
  # bioが255文字以内かつ存在するときは有効であること
  it 'is valid with a bio that has less than or equal to 255 characters' do
    recipe = FactoryBot.build(:recipe, bio: 'a' * 255)
    expect(recipe).to be_valid
  end
  
  # bioが255文字を超えるときは無効であること
  it 'is invalid with a bio that has more than 255 characters' do
    recipe = FactoryBot.build(:recipe, bio: 'a' * 256)
    expect(recipe).not_to be_valid
    expect(recipe.errors[:bio]).to include("レシピ紹介文は255文字以内で入力してください")
  end
  
  # 必須フィールドがない場合は無効であること
  it 'is invalid without a user_id' do
    recipe = FactoryBot.build(:recipe, user_id: nil)
    expect(recipe).not_to be_valid
  end

	describe 'associations' do
    it 'deletes steps when recipe is deleted' do
      recipe = FactoryBot.create(:recipe)
      step = FactoryBot.create(:step, recipe: recipe)
      expect { recipe.destroy }.to change(Step, :count).by(-1)
    end
  end

	describe 'nested attributes' do
    it 'accepts nested attributes for steps' do
      recipe_attributes = {
        name: 'テストレシピ',
        steps_attributes: [
          { process: 'ステップ1' },
          { process: 'ステップ2' }
        ]
      }
      recipe = Recipe.create(recipe_attributes)
      expect(recipe.steps.length).to eq 2
    end
  end
  
  # thumbnailやcopy_permissionに対するテストも同様に追加する
end