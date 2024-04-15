// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "bootstrap"
import "../stylesheets/application"
import "../stylesheets/recipe_index"
import "../stylesheets/sidebar"

document.addEventListener("DOMContentLoaded", function(){
	console.log("application.js");
})
