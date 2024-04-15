function addformEventListener() {
  const form = document.querySelector('form[action^="/recipes"]');
  const addformButton = document.getElementById('addformButton');
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
    form.appendChild(newField); // フォームに新しいフィールドを追加
  });
}

document.addEventListener("turbo:load", addformEventListener);