# 1. 베이스 이미지 선택 (Node.js 20 LTS 버전 사용)
FROM node:22-slim

# 2. 앱 디렉토리 생성 및 작업 디렉토리 설정
WORKDIR /usr/src/app

# 3. 의존성 설치를 위해 package.json과 package-lock.json 복사
# (소스 코드보다 먼저 복사하여 Docker 레이어 캐시를 활용)
COPY package*.json ./
RUN npm install

# 4. 애플리케이션 소스 코드 복사
COPY . .
RUN npm run tailwind

# 5. 애플리케이션이 사용할 포트 노출
EXPOSE 3000

# 6. 컨테이너 시작 시 실행할 명령어 정의
CMD [ "npm", "start" ]