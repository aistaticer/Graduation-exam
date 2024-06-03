// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@fortawesome/fontawesome-free/js/all';
import "@hotwired/turbo-rails"
import "bootstrap"
import "../stylesheets/application.scss"
import "../stylesheets/sidebar.scss"


//import Swiper from 'swiper';
//import 'swiper/swiper-bundle.css';


import $ from 'jquery';
window.$ = $;
window.jQuery = $;


// Swiperを初期化するコード
function swipe(){
  var swiper = new Swiper('.swiper-container', {
    slidesPerView: 3,  // パソコンでは3つ表示
    breakpoints: {
      0: {
        slidesPerView: 1  // 画面幅が768px以下の場合は1つ表示
      },

      768: {
        slidesPerView: 3  // 画面幅が768px以下の場合は1つ表示
      }
    },
    spaceBetween: 10,
    scrollbar: {
      el: ".swiper-scrollbar",
      hide: true,
    },
    pagination: {
      el: '.swiper-pagination',
    },
  });
};

document.addEventListener("turbo:load",swipe);
document.addEventListener("turbo:render", swipe);


document.addEventListener("DOMContentLoaded", function(){
  console.log("application.js");
})

document.addEventListener("turbo:load", () => {

  // getElementByIdで要素を取得
  const userElement = document.getElementById('user');

  // getAttributeを使う方法
  const userStateViaAttribute = userElement.getAttribute('data-user_state');
  const current_user_id = userElement.getAttribute('data-user_id');

  //userStateViaAttribute=yesならログインしている
  if (userStateViaAttribute == "no"){
    //import("./user_new_up.js").then(module => {
      // モジュールの使用
    //});
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
  }else if(window.location.pathname.startsWith('/users/edit')){
    var index = document.getElementById("edit_action")
    index.classList.add("select")
    import("./user_new_up.js").then(module => {
      // モジュールの使用
    });
    import("./user_show.js").then(module => {
      // モジュールの使用
    });
  }else if(window.location.pathname.startsWith('/users/'+ current_user_id)){
    var index = document.getElementById("user_action")
    index.classList.add("select")
  }else if(window.location.pathname.startsWith('/ranking')){
    var index = document.getElementById("ranking")
    index.classList.add("select")
  }
});

function sidebar_display() {

  const sidebarDisplay = document.getElementById('sidebar_display');
  const sideber = document.getElementById('sidebar');
  const content = document.getElementById('content');
  const list = document.getElementById('list');
  const x = document.getElementById('x');
  const user = document.getElementById('user');
  const login_state = user.getAttribute('data-user_state');

  if (login_state == "no"){
    const no_signed_container = document.getElementById('no_signed_container');
  }
  
  sidebarDisplay.addEventListener('click', function() {
    sideber.classList.toggle('sidebar_animation');
    sideber.classList.toggle('active_state'); // 'active' クラスをトグル（追加・削除）する
    if (login_state == "yes"){
      content.classList.toggle('using');
    }else{
      no_signed_container.classList.toggle('using');
    }

    list.classList.toggle('active_state');
    x.classList.toggle('active_state')
  });
};

document.addEventListener("turbo:load",sidebar_display);
//document.addEventListener("turbo:render", sidebar_display);


function flash_remove() {
  document.addEventListener("click", function(event) {
    let state = false;
    console.log(event.target.classList);
    if (event.target.closest('.flash')) {
      state = true
      console.log(state);
    }

    if (state == true) {
      var error= document.getElementById('error');
      var message = document.getElementById('message');

      error.classList.add("fade-up-out");
      error.classList.remove("fade-down-in");


      setTimeout(function() {
        message.classList.remove("message");

      }, 1000);
    }
  });
};

document.addEventListener("turbo:load",flash_remove);
