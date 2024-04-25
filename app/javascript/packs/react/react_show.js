import React, { useState, useEffect, Component } from 'react';
import ReactDOM from 'react-dom/client';
import axios from 'axios';
import {
  BrowserRouter as Router,
  Routes,
  Route,
	useLocation,
  useParams,
} from 'react-router-dom';
import { formatDistanceToNow } from 'date-fns';

function useCurrentUser() {
  const [current_user, setCurrentUser] = useState(null);

  useEffect(() => {
    const fetchComments = async () => {
      const response = await axios.get(location.href+"/comments");
      setCurrentUser(response.data.current_user);
    };
    fetchComments();
  },[]);

  return current_user;
}


function Comments() {
  const [parent_comments, setParent_comments] = useState([]);
  const [replies, setReplies] = useState([]);
  //const [current_user, setCurrentUser] = useState(null);
  const current_user = useCurrentUser();

  console.log(parent_comments)
  console.log(current_user)
  useEffect(() => {
    const fetchComments = async () => {
      const response = await axios.get(location.href+"/comments");
      console.log(response );
      console.log(location.href+"comments");
      setParent_comments(response.data.parent_comments);
      setReplies(response.data.replies);


      //setCurrentUser(response.data.current_user);
    };

    fetchComments();
  }, []);

  const postComment = async (commentData) => {
    try {
      const response = await fetch(location.href+"/comments", { // ここでのURLは適宜変更してね
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'), // CSRFトークンを設定
        },
        body: JSON.stringify(commentData),
      });
  
      if (!response.ok) {
        throw new Error('コメントの投稿に失敗しました。');
      }

      const newComment = await commentData; // 新しいコメントデータを取得 // 新しいコメントデータを取得
      
      console.log(commentData)
      //console.log(response.data.current_user)
      // 親コメントリストを更新
      //if (newComment.parent_id === null) {
      if (newComment.parent_id !== null) {
        setParent_comments(prevComments => [...prevComments, newComment]);
        console.log(newComment)
      } else {
        // 返信リストを更新
        console.log("失敗");
        setReplies(prevReplies => [...prevReplies, newComment]);
      }
  
      // コメント投稿が成功した後の処理（例: コメントリストを更新するなど）
    } catch (error) {
      console.error(error);
    }
  };
  

  const handleSubmit = (event) => {
    event.preventDefault(); // フォームのデフォルト送信を防止
    const formData = new FormData(event.target);
    const commentData = {

      body: formData.get('body'), // フォームのname属性が'comment'の入力値
      parent_id: formData.get('parent_id'),
      id: formData.get('id'),
      reply_to_id: formData.get('reply_to_id'),
      user: current_user,
      replies : [],
      created_at: new Date()
    };

    postComment(commentData);
    event.target.reset(); // フォームをリセット
  };


  /*const handleClick = (event) => {
    // event.target でクリックされた要素を取得し、
    // getAttribute('data-comment-id') で属性の値を取得する
    const commentId = event.target.getAttribute('data-comment-id');
    comment_replyform_look(commentId, "replies_");
    console.log("クリックされたよ", commentId);
  };*/

  const handleClick = () => {
    setVisible(!visible);
  };
  const [visibility, setVisibility] = useState({});
  const handleVisibilityChange = (commentId) => {
    console.log(commentId)
    // 指定されたcommentIdの要素の表示状態を切り替える
    setVisibility((prevVisibility) => ({
      ...prevVisibility,
      [commentId]: !prevVisibility[commentId],
    }));
  };

  /*const [formvisible, setFormVisible] = useState(false);
  const replyformClick = () => {
    setFormVisible(!formvisible);
  };*/

  return (

      
    <div>

      <div id = "173" className={visibility['170'] ? "hide" : "show"}>
        ににか
      </div>

      <div id = "173" className={visibility['form_170'] ? "hide" : "show"}>
        ねねか
      </div>

      <div className = "comment_container_p">コメント</div>
      {console.log("あああああああああ"+current_user?.[0].name)}

        <div className = "bottom_border">
          <div className = "comment_arrangement">
            <img src={current_user?.[0].avatar_url} className = "avater"/>
            <form onSubmit={handleSubmit} >
              <div className = "comment_arrangement">
                {console.log()}
                <input type="text" name="body" className = "form-control" required />
                <input type="hidden" name="parent_id" value={undefined}/>
                <input type="hidden" name="reply_to_id" value={undefined}/>
                <input type="hidden" name="id" value={-1}/>
                <button type="submit" className = "submit_button">送信</button>
              </div>
            </form>
          </div>
        </div>
      <div/>
      
    {parent_comments.map(parent_comment => (
      <div key={parent_comment.id}>
        <div className = "d-flex width700 space_top">
          <img src={parent_comment.user.avatar_url} className = "avater"/>
          <div  className="content_container">
            <div className='d-flex'>
              {parent_comment.user.name}
              <div className='space_left'>
                {TimeAgo(parent_comment.created_at)}
              </div>
            </div>

            <div className="body-card">
              {parent_comment.body}

              <div className='d-flex space_top'>
                <div className='replies' id={`replies_all_${parent_comment.id}`}>
                  {
                    parent_comment.replies.length > 0 ? (
                      <div className='icon-replies' data-comment-id={`${parent_comment.id}`} onClick={() => handleVisibilityChange(`reply_${parent_comment.id}`)}>
                        <i className='fa-solid fa-caret-down'></i>
                        [{parent_comment.replies.length}件の返信]
                      </div>
                    ) : (
                      <div></div>
                    )
                  }
                </div>

                <div className='d-flex align_center icon' id = {`comment_reply_button_${parent_comment.id}`} onClick={() => handleVisibilityChange(`form_${parent_comment.id}`)}>
                  <i className='fa-solid fa-reply'></i>
                  <div className='font_small'>
                    <p> 返信</p>
                  </div>
                </div>
              </div>


              {
                <form onSubmit={handleSubmit} className='' id = {`comment_replyForm_${parent_comment.id}`}>
                  <div className='comment_arrangement'>
                    <input type="text" name="body" className='form-control' required />
                    <input type="hidden" name="parent_id" value={parent_comment.id}/>
                    <input type="hidden" name="reply_to_id" value={undefined}/>
                    <input type="hidden" name="id" value={-1}/>
                    <button type="submit" className='submit_button'>親コメントに返信</button>
                  </div>
                </form>
              }
            </div>
        </div>

          </div>
          <div className={"space_top"}>
            {replies?.filter(reply => reply.parent_id === parent_comment.id)
              .map(filteredReply => (
                <div key={filteredReply.id}>

                  <div className = {visibility[`reply_${parent_comment.id}`] ? "hide" : "d-flex space_left50"}>

                    <img src={parent_comment.user.avatar_url} className = "avater-reply"/>
                    <div className='reply_container'>
                        <div className='d-flex'>
                          {parent_comment.user.name}
                          <div className='space_left'>
                            {TimeAgo(parent_comment.created_at)}
                          </div>
                        </div>
                      <div className='body-card'>
                        {filteredReply.body}
                      </div>
                  
                  

                    <form onSubmit={handleSubmit} className='hide'>
                      <div className='comment_arrangement'>
                        <input type="text" name="body" className='form-control' required />
                        <input type="hidden" name="parent_id" value={parent_comment.id}/>
                        <input type="hidden" name="reply_to_id" value={filteredReply.id}/>
                        <input type="hidden" name="id" value={-1}/>
                        <button type="submit" className='submit_button'>返信コメントに返信</button>
                      </div>
                    </form>
                    </div>
                  </div>
                </div>
            ))}
          </div>
      </div>
    ))}

    </div>
  );
}

function TimeAgo( timestamp ) {
  console.log(timestamp)
  const timeAgo = formatDistanceToNow(new Date(timestamp), { addSuffix: true });
  return <div>{timeAgo}</div>;
}

function comment_replyform_look(commentId,classname){
  let comment_replyform = document.getElementById(classname + commentId)
  if(comment_replyform.classList.contains("show") == true){
    comment_replyform.classList.add("hide");
    comment_replyform.classList.remove("show");
  }else if(comment_replyform.classList.contains("hide") == true){
    comment_replyform.classList.add("show");
    comment_replyform.classList.remove("hide");
  }
}

const root = ReactDOM.createRoot(document.getElementById('root'));
const root1 = ReactDOM.createRoot(document.getElementById('root1'));

root1.render(<Comments />);