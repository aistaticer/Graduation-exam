import "../stylesheets/recipe_show.scss"

document.addEventListener("DOMContentLoaded", function(){
	console.log("show.js");
})

// コメントIDを保持する配列
let shownComments = [];

function comment_replyform_look(commentId,classname){
  let comment_replyform = document.getElementById(classname + commentId)
  if(comment_replyform.classList.contains("show") == true){
    comment_replyform.classList.add("hide");
    comment_replyform.classList.remove("show");

    // 配列からコメントIDを削除
    const index = shownComments.indexOf(commentId);
    if (index > -1) {
      shownComments.splice(index, 1);
    }
  }else if(comment_replyform.classList.contains("hide") == true){
    comment_replyform.classList.add("show");
    comment_replyform.classList.remove("hide");

    // 配列にコメントIDを追加
    if (!shownComments.includes(commentId)) {
      shownComments.push(commentId);
      console.log(shownComments);
    }
  }
}


$(document).on('click', '.icon', function() {
  comment_replyform_look($(this).data('comment-id'), 'comment_replyForm_');
});

$(document).on('click', '.icon-replies', function() {
  comment_replyform_look($(this).data('comment-id'), 'replies_');
});

document.addEventListener("DOMContentLoaded", function() {
  // commentWithReplyIds からクラスを変更する
  commentWithReplyIds.forEach(function(id) {
    var element = document.getElementById("replies_" + id);
    if (element && element.classList.contains("show")) {
      element.classList.remove("show");
      element.classList.add("hide");
    }
  });
});

