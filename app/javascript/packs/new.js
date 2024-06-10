import "../stylesheets/recipe_new.scss";
import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';

function addformEventListener() {

  const addformButton = document.getElementById('addformButton');
  let process_number = document.querySelectorAll('.form-control.form-control-custom').length;

  addformButton.addEventListener('click', function(e) {

    process_number++;
    const newField = document.createElement('div'); // 新しいフォーム要素のコンテナ

    newField.innerHTML = `
      <div = class = "margin-top">
        <div class = "d-flex height40">
          <div class = "number">    
            ${process_number}
          </div>
          <input type="hidden" name="recipe[steps_attributes][${process_number}][number]" value="${process_number}">
          <textarea name="recipe[steps_attributes][${process_number}][process]" placeholder="作り方を入力してください" class="form-control form-control-custom height40"></textarea>
        </div>
      </div>
    `;

    document.getElementById('process_form').appendChild(newField);
    addformButton.scrollIntoView();
    initializeTextarea()
  });
}

document.addEventListener("turbo:load", addformEventListener);

function addingre_form(){
  let process_number = 0;
  const addingreformButton = document.getElementById('addingreformButton'); // ボタンのIDがこれだと仮定
  
  addingreformButton.addEventListener('click', function(e) {
    e.preventDefault(); // ボタンのデフォルトの動作を防ぐ
    process_number++; // フォームを追加するたびに数を増やす

    const newField = document.createElement('div'); // 新しいフォーム要素のコンテナ
    newField.className = "d-flex";
    newField.innerHTML = `
        <textarea name="recipe[ingredients_attributes][${process_number}][name]" placeholder="材料名" class="ingre_form width200"></textarea>
        <textarea name="recipe[ingredients_attributes][${process_number}][quantity]" placeholder="量 50ccなど" class="ingre_form width200 margin-left"></textarea>
    `;

    // フォームを追加する場所を指定する。例えば、idが`formContainer`の要素の中に追加。
    document.getElementById('ingredients_form').appendChild(newField);
    
    scrollToElementWithOffset('uso', 150);
    //addingreformButton.scrollIntoView();
    initializeTextarea()
  });
}

document.addEventListener("turbo:load", addingre_form);

function scrollToElementWithOffset(elementId, offset) {
  const element = document.getElementById(elementId);
  if (element) {
    element.scrollIntoView(true); // 要素の上部までスクロール
    window.scrollBy(0, -offset); // オフセットを追加
  }
}

document.addEventListener('DOMContentLoaded', (event) => {
  document.getElementById('fileInput').addEventListener('change', function() {
  });
});

function imagepreview(){
  $('#fileInput').change(function() {

    // ファイル情報を取得
    var file = this.files[0];
    
    // ファイル名を取得
    var fileName = file.name;
    
    // ファイルサイズを取得（バイト単位）
    var fileSize = file.size;
    
    // 画面に表示する
    $('#fileInfo').text('ファイル名: ' + fileName + ', サイズ: ' + fileSize + 'バイト');
  
        // FileReaderオブジェクトの作成
    var reader = new FileReader();

    // ファイルが読み込まれたときのイベントハンドラを設定
    reader.onload = function(e) {
      // 読み込んだ画像データをsrc属性に設定して、画像を表示
      $('#imagePreview').attr('src', e.target.result);
    };

    // ファイルをDataURLとして読み込む
    reader.readAsDataURL(file);
  });
};

document.addEventListener("turbo:load", imagepreview);

$(document).ready(function() {
  $('#category').select2();
  console.log("aaaa");
});

function imageclick(){
  const setImage = document.getElementById('imagePreview')
  setImage.addEventListener('click', function() {
    document.getElementById('fileInput').click();
  })
}

document.addEventListener("turbo:load", imageclick);

function initializeTextarea() {
  $('textarea').each(function () {
    this.style.overflowY = 'hidden';
    this.style.height = (this.scrollHeight) + 'px';
    this.baseScrollHeight = this.scrollHeight;
  }).off('input').on('input', function () {
    if (this.scrollHeight > this.baseScrollHeight) {
      this.style.height = (this.scrollHeight) + 'px';
    }
  });
}

document.addEventListener("turbo:load", initializeTextarea);

function stepform() {

  let targetElement;
  let number = 0;
  let judge;
  const new_container = document.getElementById('new_container');
  const move_button = document.getElementById('move_button');
  const process = document.getElementById('step_form_number6');

  document.addEventListener("click", function(e) {


    const targetClasses = ["advance", "b"];

    while (targetElement && !hasTargetClass(targetElement, targetClasses)) {
      targetElement = targetElement.parentElement;
    }

    // 次へのボタンが押されたらtrue,前へならfalseを返す
    judge = move_botton(e)

    //　ボタンの種類によってnumberを更新
    switch (judge) {
      case 'advance':
        number = number+1
        if(number > 7){
          number = 7;
        }
        break;
      case 'back':
        number = number-1
        if(number < 0){
          number = 0;
        }
        break;
    }

    // 次へもしくは前へボタンを押してたら
    if(judge){
      for (let i = 0; i <= 7; i++) {
        const direction = document.getElementById('direction' + i);
        const step_form = document.getElementById('step_form_number' + i);
        const now_content = document.getElementById('now_content' + i);

        if (i == number) {

          console.log(i)

          new_container.style.display = 'block';
          
          direction.classList.remove('none');
          direction.classList.add('animate_r')
          
          step_form.classList.remove('none');
          step_form.classList.add('animate_r')
          
          now_content.classList.add('now_content');

          // 最後になったら全てのフォームを表示して、ボタンを消す
          if(number == 7){
            if (window.innerWidth >= 768) {
              var newContainer = document.getElementById('new_container');
              newContainer.style.display = 'flex';
            }

            new_container.classList.remove('margin-left');
            new_container.classList.remove('margin-top');
            new_container.classList.add('new_back');
            new_container.classList.add('animate_r');

            move_button.classList.add('none');

            process.style.height = "auto"

            for(let num = 0; num <= 7; num++){
              const step_form = document.getElementById('step_form_number' + num);
              step_form.classList.add('margin-top25');     
              step_form.classList.remove('none');
              console.log(step_form.id)
            }
          }

        } else {
          direction.classList.add('none');
          step_form.classList.add('none');
          now_content.classList.remove('now_content');
        }
      }
    }
  })
}

function move_botton(e){

  let move_botton;
  let result;

  move_botton = e.target;
  while (move_botton && !move_botton.classList.contains('advance') && !move_botton.classList.contains('back')) {
    move_botton = move_botton.parentElement;
  }

  if(move_botton){
    switch (move_botton.id) {
      case 'advance':
        result = 'advance';
        break;
      case 'back':
        result = 'back';
        break;
    }
  }

  return result;
}

document.addEventListener("turbo:load", stepform);

