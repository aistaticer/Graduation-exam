SitemapGenerator::Sitemap.default_host = "https://evolution-recipes-949263457034.herokuapp.com/"

SitemapGenerator::Sitemap.create do

  add root_path, :priority => 1.0, :changefreq => 'daily'
  add pages_home_path, :priority => 0.7, :changefreq => 'daily'

  add new_user_registration_path, :priority => 0.8, :changefreq => 'monthly'
  add new_user_session_path, :priority => 0.8, :changefreq => 'monthly'
  add new_user_password_path, :priority => 0.8, :changefreq => 'monthly'

  add recipes_path, :priority => 0.7, :changefreq => 'daily'

  Recipe.find_each do |recipe|
    add recipe_path(recipe), :lastmod => recipe.updated_at
  end

end
