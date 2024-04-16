// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "bootstrap"
import "../stylesheets/application"
import "../stylesheets/recipe_index"
import "../stylesheets/sidebar"
import "../stylesheets/recipe_new"
//import "./react/react_example"
//import "./react/react_new"
//import "./new"
import $ from 'jquery';
window.$ = $;
window.jQuery = $;

document.addEventListener("DOMContentLoaded", function(){
	console.log("application.js");
})
