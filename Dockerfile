FROM alpine:latest AS tailwind-builder

# Docker BuildKit이 제공하는 자동 아키텍처 변수. '--platform' 플래그에 따라 변경됨.
ARG TARGETARCH

WORKDIR /app

RUN apk add --no-cache curl && \
    curl -sLo./tailwindcss https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-${TARGETARCH} && \
    chmod +x./tailwindcss

COPY . .

RUN ./tailwindcss -i./src/input.css -o ./build/output.css --minify

FROM node:22-alpine AS runner

WORKDIR /app

# 프로덕션에 필요한 종속성만 설치하기 위해 package.json 파일을 먼저 복사합니다.
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY --from=tailwind-builder /app/public/output.css ./public/css/output.css

COPY . .

EXPOSE 80

CMD [ "npm", "start" ]