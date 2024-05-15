import "../stylesheets/recipe_new.scss";
import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener("DOMContentLoaded", function(){
	console.log("new.js");
})

function addformEventListener() {
  const form = document.querySelector('form[action^="/recipes"]');
  const addformButton = document.getElementById('addformButton');
  const submit = document.getElementById('submit');
  let process_number = document.querySelectorAll('.form-control.form-control-custom').length;
  console.log(process_number);

  addformButton.addEventListener('click', function(e) {
    //e.preventDefault(); // ページのリロードを防ぐ
    console.log(process_number)
    process_number++;
    const newField = document.createElement('div'); // 新しいフォーム要素のコンテナ


    newField.innerHTML = `
      <div = class = "form margin-top margin-left">
        <div class = "d-flex width80">
          <div class = "number">    
            ${process_number}
          </div>
          <input type="hidden" name="recipe[steps_attributes][${process_number}][number]" value="${process_number}">
          <textarea name="recipe[steps_attributes][${process_number}][process]" placeholder="ここにテキストを入力してください" class="form-control"></textarea>
        </div>
      </div>
    `;

    const parentElement = submit.parentNode;
    parentElement.insertBefore(newField,submit);
    document.getElementById('step').appendChild(newField);

    newField.scrollIntoView();
  });
}

document.addEventListener("turbo:load", addformEventListener);
document.addEventListener("turbo:render", addformEventListener);

function addingre_form(){
  let process_number = 0;
  const addingreformButton = document.getElementById('addingreformButton'); // ボタンのIDがこれだと仮定
  addingreformButton.addEventListener('click', function(e) {
    e.preventDefault(); // ボタンのデフォルトの動作を防ぐ
    process_number++; // フォームを追加するたびに数を増やす

    const newField = document.createElement('div'); // 新しいフォーム要素のコンテナ
    newField.className = "d-flex margin-top";
    newField.innerHTML = `
        <textarea name="recipe[ingredients_attributes][${process_number}][name]" placeholder="材料名" class="ingre_form"></textarea>
        <textarea name="recipe[ingredients_attributes][${process_number}][quantity]" placeholder="量 50ccなど" class="ingre_form margin-left"></textarea>
    `;

    // フォームを追加する場所を指定する。例えば、idが`formContainer`の要素の中に追加。
    document.getElementById('ingredients_form').appendChild(newField);
    newField.scrollIntoView();
  });
}

document.addEventListener("turbo:load", addingre_form);
document.addEventListener("turbo:render", addingre_form);


document.addEventListener('DOMContentLoaded', (event) => {
  document.getElementById('fileInput').addEventListener('change', function() {
    console.log("aaa");
    // 以下、ファイル選択後の処理。
  });
});

function imagepreview(){
  $('#fileInput').change(function() {

    console.log("画像きた");
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
document.addEventListener("turbo:render", imagepreview);

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
document.addEventListener("turbo:render", imageclick);

function initializeTextarea() {
  $('textarea').each(function () {
    this.style.overflowY = 'hidden';
    this.style.height = (this.scrollHeight) + 'px';
    this.baseScrollHeight = this.scrollHeight;
  }).off('input').on('input', function () {
    //this.style.height = 'auto';
    if (this.scrollHeight > this.baseScrollHeight) {
      this.style.height = (this.scrollHeight) + 'px';
    }
  });
}

document.addEventListener("turbo:load", initializeTextarea);
document.addEventListener("turbo:render", initializeTextarea);



