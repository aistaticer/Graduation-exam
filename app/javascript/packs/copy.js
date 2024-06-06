document.addEventListener("DOMContentLoaded", function(){
	console.log("copy.js");
})

document.addEventListener('DOMContentLoaded', () => {
  var stepElement = document.getElementById("steps");
  var steps = JSON.parse(stepElement.dataset.steps);
  var name = JSON.parse(stepElement.dataset.recipe_name);

  document.getElementById("askOpenAI").addEventListener("click", function() {
    // 出力中のメッセージを表示
    var resultElement = document.getElementById('result');
    resultElement.innerHTML = "出力中...";

    fetch('/path_to_your_action', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
        'Content-Type': 'application/json',
      },
      body: 
        JSON.stringify({
          recipe_steps: steps,
          recipe_name: name
        }),
    })
    .then(response => response.json())
    .then(data => {
      resultElement.classList.add('margin');
      resultElement.innerHTML = data.content; // 結果を表示する要素のIDに置き換える
    });
  });
});



document.addEventListener('DOMContentLoaded', function() {
  document.getElementById("ai").addEventListener('mouseenter', function() {
    document.getElementById("append").style.display = 'block';
  });

  document.getElementById("ai").addEventListener('mouseleave', function() {
    document.getElementById("append").style.display = 'none';
  });
});