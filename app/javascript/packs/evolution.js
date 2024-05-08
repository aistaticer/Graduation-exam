import '../stylesheets/evolution.scss';


function evolution_figure(){

  const canvas = document.getElementById('canvas');
  const rect = canvas.getBoundingClientRect();
  const top = 200;
  const left = 300;

	const recipes = document.getElementById('recipes');

	var recipe_power = JSON.parse(recipes.dataset.recipe_power);
	var recipe_id = JSON.parse(recipes.dataset.recipe_id);
	
  if (recipe_power.length > 3){
  	canvas.width = recipe_power.length * 50; // Canvasの幅を設定
  }else{
    canvas.width = 200;
  }
  
  canvas.height = 200; // Canvasの高さを設定
	const ctx = canvas.getContext('2d');
	var height = canvas.height
	var width = canvas.width
  var x1;
  var y1;
  var x2;
  var y2;

  console.log(left);

  create_letter(left - 70,top,"注目度")
  create_letter(left + width - 50,top + height + 30,"レシピ")


	for (let i = 0; i < recipe_power.length-1; i++) {
		x1 = i*50 + 20 + 10;
		y1 = recipe_power[i] * 10 + 50
		x2 = (i+1)*50 + 20 + 10;
		y2 = recipe_power[i+1] * 10 + 50
		line_draw(ctx,x1,y1,x2,y2,height)
	}

  var recipe_coordinates = [];
  var juel = [];
  var introduce = [];

  const a = document.getElementById('a');
	for (let i = 0; i < recipe_power.length; i++) {
    var x = i*50 + 30 + left
    var y = height + top - (recipe_power[i] * 10 + 50)
		drawCircle(ctx,x,y,height)

    recipe_coordinates.push([x,y]);

    juel[i] = document.getElementById(`${recipe_id[i]}`);
    juel[i].style.position = 'absolute';
    juel[i].style.left = x - 10 + 'px';
    juel[i].style.top = y - 10 + 'px';

    a.style.left = rect.x  - window.scrollY + 'px'
    a.style.top = rect.y  - window.scrollY + 'px'

    introduce[i] = document.getElementById(`introduce_${recipe_id[i]}`);
    introduce[i].style.position = 'absolute';
    introduce[i].style.left = x + 'px';
    introduce[i].style.top = y - 100 + 'px';

    document.getElementById(`${juel[i].id}`).addEventListener('mouseenter', function() {
      document.getElementById(`introduce_${recipe_id[i]}`).style.display = 'block';
    });

    document.getElementById(`set_${recipe_id[i]}`).addEventListener('mouseleave', function() {
      document.getElementById(`introduce_${recipe_id[i]}`).style.display = 'none';
    });
    
	}

  // x軸とy軸の描写
  //y軸について
	line_draw(ctx,10,10,10,height-10,height) 
  line_draw(ctx,10,height-10,5,height -15,height)
  line_draw(ctx,10,height-10,15,height -15,height)

  //x軸について
	line_draw(ctx,10,10,width-10,10,height)
  line_draw(ctx,width-10,10,width - 15,15,height)
  line_draw(ctx,width-10,10,width - 15,5,height)


  drawCircle(ctx,recipe_coordinates[0][0],recipe_coordinates[0][1],height)

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

