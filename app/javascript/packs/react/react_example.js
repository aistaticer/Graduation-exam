import React, { useState } from 'react';
import ReactDOM from 'react-dom/client';

document.addEventListener("DOMContentLoaded", function(){
	console.log("react_example.js");
})

function App() {
  // 入力フォームのリストを管理するstate
  const [forms, setForms] = useState([]);

  // フォームを追加する関数
  const addForm = () => {
    // 新しいフォーム（ここでは空の文字列）をforms配列に追加
    setForms([...forms, '']);
  };

  return (
    <div>
      {/* ボタンをクリックした時にaddForm関数を実行 */}
      <button onClick={addForm}>フォームを追加</button>
      
      {/* forms配列をマッピングして、各フォームを表示 */}
      {forms.map((form, index) => (
        <form key={index}>
          <input type="text" placeholder={`フォーム #${index + 1}`} />
          <button type="submit">送信</button>
        </form>
      ))}
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
//root.render(<App />);

