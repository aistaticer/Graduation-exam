function evolution_figure(){
	const canvas = document.getElementById('canvas');
	canvas.width = 200; // Canvasの幅を設定
	canvas.height = 200; // Canvasの高さを設定
	const ctx = canvas.getContext('2d');

	ctx.beginPath(); // 新しいパスを開始
	ctx.moveTo(0.5, 0); // パスの開始座標を設定
	ctx.lineTo(100.5, 100); // 終点の座標を設定
	ctx.stroke(); // 描画
}

document.addEventListener("turbo:load", evolution_figure);