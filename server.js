// server.js
const express = require('express');
const app = express();

app.use(express.static('public')); // publicディレクトリにある静的イル提供

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
});