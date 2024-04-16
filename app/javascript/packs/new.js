function addformEventListener() {
  const form = document.querySelector('form[action^="/recipes"]');
  const addformButton = document.getElementById('addformButton');
  const submit = document.getElementById('submit');
  let process_number = form.querySelectorAll('.form-control').length - 2;

  addformButton.addEventListener('click', function(e) {
    //e.preventDefault(); // ページのリロードを防ぐ
    process_number++;
    const newField = document.createElement('div'); // 新しいフォーム要素のコンテナ
    newField.innerHTML = `
      <br>
      ${process_number}
      <input type="hidden" name="recipe[steps_attributes][${process_number}][number]" value="${process_number}">
      <textarea name="recipe[steps_attributes][${process_number}][process]" placeholder="ここにテキストを入力してください" class="form-control"></textarea>
      <br>
    `;
    //submit.appendChild(newField); // フォームに新しいフィールドを追加
    const parentElement = submit.parentNode;
    parentElement.insertBefore(newField,submit);

    newField.scrollIntoView();
  });
}

document.addEventListener("turbo:load", addformEventListener);

document.addEventListener('DOMContentLoaded', (event) => {
  document.getElementById('fileInput').addEventListener('change', function() {
    console.log("aaa");
    // 以下、ファイル選択後の処理。
  });
});

function handleFileSelect(input) {
  console.log("aaa");
  /*if (input.files && input.files[0]) {
    // ここでファイル選択後の処理を書く。例えば画像プレビュー表示など。
    var reader = new FileReader();
    
    reader.onload = function(e) {
      // 例えば、読み込んだ画像をプレビューする
      document.getElementById('imagePreview').src = e.target.result;
    }
    
    reader.readAsDataURL(input.files[0]);
  }*/
}


function a(){
  const fileInput = document.getElementById('fileInput');
  if (fileInput != null){
    addEventListener('change', function() {
      console.log('ファイルが選択されました！');

    });
    console.log(fileInput.id);
  }
}
document.addEventListener("turbo:load", a);

//document.addEventListener("turbo:load", handleFileSelect);

$(document).ready(function() {
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
});

/*document.getElementById('imagePreview').addEventListener('click', function() {
  document.getElementById('fileInput').click();
});*/

function imageclick(){
  const setImage = document.getElementById('imagePreview')
  setImage.addEventListener('click', function() {
    document.getElementById('fileInput').click();
  })
}

document.addEventListener("turbo:load", imageclick);