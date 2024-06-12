namespace :sitemap do
  desc "Generate sitemap.xml"
  task generate: :environment do
    require 'xml-sitemap'

    host = 'https://evolution-recipes-949263457034.herokuapp.com'  # 自分のドメインに変更する
    map = XmlSitemap::Map.new(host) do |m|
      # 静的なページ
      m.add '/', period: :monthly, priority: 1.0
      m.add '/privacy_policy', period: :yearly
      m.add '/contact', period: :yearly

      # 動的なページ
      User.find_each do |user|
        m.add user_path(user), period: :weekly
      end

      Recipe.find_each do |recipe|
        m.add recipe_path(recipe), period: :daily
        m.add copy_and_new_recipes_path, period: :monthly
        m.add evolution_recipes_path, period: :monthly
        m.add search_recipes_path, period: :monthly
      end

      # 管理者用ページ（必要なら追加）
      m.add '/admin/dashboard', period: :monthly
      Admin::Recipe.find_each do |recipe|
        m.add admin_recipe_path(recipe), period: :daily
      end
      Admin::User.find_each do |user|
        m.add admin_user_path(user), period: :weekly
      end
      m.add '/admin/comments', period: :daily
    end

    map.render_to('public/sitemap.xml')
  end
end
