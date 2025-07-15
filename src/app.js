const express = require("express");
const path = require("path");

const app = express();
const port = 80;

// 'public' 폴더를 정적 파일 제공을 위한 디렉토리로 설정합니다.
app.use(express.static(path.join(__dirname, "..", "public")));

app.listen(port, () => console.log(`server running on port ${port}`));
