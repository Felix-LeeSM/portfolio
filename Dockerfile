FROM alpine:latest AS tailwind-builder

# Docker BuildKit이 제공하는 자동 아키텍처 변수. '--platform' 플래그에 따라 변경됨.
ARG TARGETARCH

WORKDIR /app

RUN apk add --no-cache curl && \
    curl -sLo ./tailwindcss https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-${TARGETARCH} && \
    chmod +x ./tailwindcss

COPY . .

RUN ./tailwindcss -i./src/input.css -o ./build/output.css --minify

FROM node:22-alpine AS runner

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY --from=tailwind-builder /app/build/output.css ./public/css/output.css

COPY . .

EXPOSE 80

CMD [ "npm", "start" ]