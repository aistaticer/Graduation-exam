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

function Comments() {
  const [parent_comments, setParent_comments] = useState([]);
  const [replies, setReplies] = useState([]);
  const [current_user, setCurrentUser] = useState(null);
  console.log(parent_comments)
  console.log(current_user)
  useEffect(() => {
    const fetchComments = async () => {
      const response = await axios.get(location.href+"/comments");
      console.log(response );
      console.log(location.href+"comments");
      setParent_comments(response.data.parent_comments);
      setReplies(response.data.replies);
      setCurrentUser(response.data.current_user);
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
    };

    postComment(commentData);
    event.target.reset(); // フォームをリセット
  };

  return (


      <div className = "comment_container">
        <p>コメント</p>
        <div className = "bottom_border">
          <div className = "comment_arrangement">
            <form onSubmit={handleSubmit}>
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
      


      <h2>Comments</h2>
      {parent_comments.map(parent_comment => (
        <div key={parent_comment.id}>
          {//parent_comment.user.name
          }
          {parent_comment.body}
          {console.log(current_user[0].name)
          }
          
          {
            <form onSubmit={handleSubmit}>
              <input type="text" name="body" required />
              <input type="hidden" name="parent_id" value={parent_comment.id}/>
              <input type="hidden" name="reply_to_id" value={undefined}/>
              <input type="hidden" name="id" value={-1}/>
            <button type="submit">親コメントに返信</button>
            </form>
          }
          {replies?.filter(reply => reply.parent_id === parent_comment.id)
            .map(filteredReply => (
              <div key={filteredReply.id}>{filteredReply.body}
                  <form onSubmit={handleSubmit}>
                    <input type="text" name="body" required />
                    <input type="hidden" name="parent_id" value={parent_comment.id}/>
                    <input type="hidden" name="reply_to_id" value={filteredReply.id}/>
                    <input type="hidden" name="id" value={-1}/>
                  <button type="submit">返信コメントに返信</button>
                  </form>
              </div>
          ))}
        </div>
      ))}
    </div>
  );
}

class Greeting extends Component {
  render() {
    return(
      <div>
        <h1>Hello, world.</h1>
        <h2>Hi, everyone.</h2>
      </div>
    );
  }
}

function CommentApp() {

  // コメントのリストを保持するstate
  const [comments, setComments] = useState([]);

  // コメントを投稿する関数
  const postComment = async (commentData) => {
    try {
      const response = await fetch('/recipes/1/comments', { // ここでのURLは適宜変更してね
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
  
      // コメント投稿が成功した後の処理（例: コメントリストを更新するなど）
    } catch (error) {
      console.error(error);
    }
  };
  
  const handleSubmit = (event) => {
    event.preventDefault(); // フォームのデフォルト送信を防止
    const formData = new FormData(event.target);
    const commentData = {
      comment: { // バックエンドが期待する形式に合わせてネストする
        body: formData.get('comment'), // フォームのname属性が'comment'の入力値
        // 他に必要なデータがあればここに追加
      }
    };
    postComment(commentData);
    event.target.reset(); // フォームをリセット
  };
  
 
  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input type="text" name="comment" required />
        <button type="submit">コメントを投稿</button>
      </form>
      <div>
        {comments.map((comment, index) => (
          <div key={index}>{comment.text}</div> // コメントを表示
        ))}
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));










function Recipe() {
  // useParamsフックを使ってURLパラメータを取得
  let { id } = useParams();
  return <div>レシピのIDは {id} だね。</div>;
}

function A() {
  let params = useParams();
  return <div>Params: {JSON.stringify(params)}</div>;
}



/*function App() {
  // コメントのリストを保持するための状態
  const [comments, setComments] = useState([]);
  // 新しいコメントのテキストを保持するための状態
  const [newComment, setNewComment] = useState('');

  // コンポーネントのマウント時にコメントを読み込む
  useEffect(() => {
    // ここでコメントの初期読み込みをする（例: APIからfetch）
    // fetchComments();
  }, []);

  const handleSubmit = async (e) => {
		e.preventDefault();
		// 新しいコメントをサーバーに送る
		try {
			const response = await fetch('comments', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify({ comment: newComment }), // 送りたいデータ
			});
			if (response.ok) {
				const savedComment = await response.json(); // サーバーからのレスポンスを受け取る
				setComments([...comments, savedComment]); // 保存されたコメント（レスポンス）をリストに追加
				setNewComment(''); // 入力フィールドをクリア
			} else {
				// エラーハンドリング
				console.error('コメントの保存に失敗しました。');
			}
		} catch (error) {
			// エラーハンドリング
			console.error('コメントの保存中にエラーが発生しました。', error);
		}
	};

  return (
    <div>
      <h2>コメント</h2>
      <ul>
        {comments.map((comment, index) => (
          <li key={index}>{comment}</li>
        ))}
      </ul>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={newComment}
          onChange={(e) => setNewComment(e.target.value)}
        />
        <button type="submit">コメントを追加</button>
      </form>
    </div>
  );
}*/

//const root = ReactDOM.createRoot(document.getElementById('root'));
const root1 = ReactDOM.createRoot(document.getElementById('root1'));
root1.render(<Comments />);
//root1.render(<CommentApp />);
//root.render(<Recipe />);