import "../stylesheets/evolution.scss";

function evolution_figure(){

  const flame = document.getElementById('flame');

  // recipesクラスからレシピのいいね数を取得
  const recipes = document.getElementById('recipes');
  var recipe_power = JSON.parse(recipes.dataset.recipe_power);
  var recipe_id = JSON.parse(recipes.dataset.recipe_id);
  var juel2 = [];
  var introduce = [];
  var introduce_state = false;
  var introduce_number = null;


  flame.style.width = recipe_power.length * 60 +500 + "px";

  document.body.addEventListener('click', function(e) {
    if(!e.target.closest('.juel') && introduce_state == true)  {
      introduce[introduce_number].classList.toggle('hide');
      introduce_number = null
      introduce_state = false
    }
  })
  
  

  for (let i = 0; i < recipe_power.length; i++) {
    juel2[i] = document.getElementById(`${recipe_id[i]}`);
    juel2[i].style.position = 'absolute';
    juel2[i].style.left = i*60 + 'px';
    if(recipe_power[i]> 29){
      recipe_power[i] = 29
    }

    console.log(recipe_power[i] * 150)
    juel2[i].style.top = - recipe_power[i] * 10 + flame.offsetHeight - 30 + 'px';

    introduce[i] = document.getElementById(`introduce_${recipe_id[i]}`);
    introduce[i].style.position = 'absolute';
    introduce[i].style.left = i*60 + 30 + "px";
    introduce[i].style.top = - recipe_power[i] * 10 + flame.offsetHeight - 120+ 'px';
  
    juel2[i].addEventListener('click', function(event) {
      console.log(introduce_state)
      if(introduce_state == false){
        console.log(111)
        introduce[i].classList.toggle('hide');
        introduce_state = true;
        introduce_number = i;
      }
    })
  }
}

function create_letter(x,y,text){
  let content = document.createElement('div'); // 'div'に変更
  content.classList.add("text");
  content.textContent = text;
  content.style.position = 'absolute';
  content.style.left = x + 'px'; // 'px'を追加
  content.style.top = y + 'px'; // 'px'を追加
  document.body.appendChild(content); // 追加する要素をbodyに追加
}



function line_draw(ctx,x1,y1,x2,y2,height){

	y1 = height - y1
	y2 = height - y2

	ctx.beginPath(); // 新しいパスを開始
	ctx.moveTo(x1, y1); // パスの開始座標を設定
	ctx.lineTo(x2, y2); // 終点の座標を設定
	ctx.stroke(); // 描画
}

function drawCircle(ctx,x,y,height) {
  if (ctx) {
    y = height - y

    // 円を描画するための設定
    ctx.beginPath(); // パスの開始
    ctx.arc(x, y, 6, 0, 2 * Math.PI); // 円の描画 (x, y, radius, startAngle, endAngle)
    ctx.fillStyle = 'red'; // 色を赤に設定
    ctx.fill(); // 円の中を塗りつぶす
    ctx.stroke(); // 円を描画
  }
}

document.addEventListener("turbo:load", evolution_figure);

