#spec/factories/recipes.rb


FactoryBot.define do
  factory :recipe do
    user_id { 1 }
    name { "テストレシピ" }
    bio { "これはテスト用のレシピです。" }
    thumbnail { 
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'support', 'test_thumbnail.jpg'), 
        'image/jpeg'
      )
    }
    copy_permission { true }
    genre
    menu
  end
end