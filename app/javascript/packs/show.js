function comment_replyform_look(commentId,classname){
  let comment_replyform = document.getElementById(classname + commentId)
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
      comment_replyform_look(commentId, 'comment_replyForm_');
      console.log('コメントID:', commentId);
      console.log("クリックを感知")
    });
  });
});

document.addEventListener('DOMContentLoaded', function() {
  console.log("アイコンからコメントIDを受け取る関数");
  var iconreplies_all = document.querySelectorAll('.icon-replies');

  iconreplies_all.forEach(function(iconreplies){
    iconreplies.addEventListener('click', function(e) {
      var commentId = iconreplies.getAttribute('data-comment-id');
      comment_replyform_look(commentId,"replies_");
    })
  })
});



document.addEventListener('click', function(event) {
	const clickedElement = event.target;
	console.log(clickedElement);
});
