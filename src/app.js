const express = require("express");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.static(path.join(__dirname, "..", "public")));

app.listen(port, (err) => {
  if (err) console.error(err);
  else console.log(`server running on port ${port}`);
});
