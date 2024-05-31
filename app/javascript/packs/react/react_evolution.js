import React, { useState } from 'react';

const Counter = () => {
  // useStateフックでカウンターの状態を管理
  const [count, setCount] = useState(0);

  // カウントを増やす関数
  const increment = () => setCount(count + 1);

  return (
    <div>
      <p>カウント: {count}</p>
      <button onClick={increment}>カウントを増やす</button>
    </div>
  );
};

export default Counter;



document.addEventListener("DOMContentLoaded", function(){
	console.log("evolution");
})