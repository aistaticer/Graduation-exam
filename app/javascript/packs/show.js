function comment_replyform_look(commentId){
  let comment_replyform = document.getElementById('comment_replyForm_' + commentId)
  if(comment_replyform.className == "show"){
    comment_replyform.classList.add("hide");
    comment_replyform.classList.remove("show");
  }else if(comment_replyform.className == "hide"){
    comment_replyform.classList.add("show");
    comment_replyform.classList.remove("hide");
  }
}

document.addEventListener('DOMContentLoaded', function() {
  console.log("アイコンからコメントIDを受け取る関数");
  // アイコンを取得
  var icons = document.querySelectorAll('.icon');
  
  icons.forEach(function(icon){

    // クリックイベントリスナーを追加
    icon.addEventListener('click', function(e) {
      // このアイコンが持つdata-comment-idの値を取得
      var commentId = icon.getAttribute('data-comment-id');
      // コンソールに表示
      comment_replyform_look(commentId);
      console.log('コメントID:', commentId);
      console.log("クリックを感知")
    });
  });
});



document.addEventListener('click', function(event) {
	const clickedElement = event.target;
	console.log(clickedElement);
});
