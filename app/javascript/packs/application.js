// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@fortawesome/fontawesome-free/js/all';
import "@hotwired/turbo-rails"
import "bootstrap"

import '../stylesheets/application.scss';
import "../stylesheets/sidebar.scss"

import $ from 'jquery';
window.$ = $;
window.jQuery = $;

document.addEventListener("DOMContentLoaded", function(){
	console.log("application.js");
})

document.addEventListener("turbo:load", () => {

  // getElementByIdで要素を取得
  const userElement = document.getElementById('user');

  // getAttributeを使う方法
  const userStateViaAttribute = userElement.getAttribute('data-user_state');
  console.log(userStateViaAttribute)
  if (userStateViaAttribute == "no"){
    import("./user_new_up.js").then(module => {
      // モジュールの使用
    });
    return
  }

  if (window.location.pathname === '/recipes/new') {
    var index = document.getElementById("new_action")
    index.classList.add("select")
  }else if(window.location.pathname === '/recipes'){
    var index = document.getElementById("index_action")
    index.classList.add("select")
  }else if(window.location.pathname === '/likes'){
    var index = document.getElementById("likes_action")
    index.classList.add("select")
  }else if(window.location.pathname.startsWith('/users')){
    var index = document.getElementById("user_action")
    index.classList.add("select")
  }
});


