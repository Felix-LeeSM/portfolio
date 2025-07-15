FROM alpine:latest AS tailwind-builder

# Docker BuildKit이 제공하는 자동 아키텍처 변수를 설정합니다.
ARG TARGETARCH
ARG TAILWIND_VERSION=v4.1.11

WORKDIR /app

RUN apk add --no-cache curl libstdc++ libgcc && \
    DOWNLOAD_ARCH=${TARGETARCH} && \
    if [ "${TARGETARCH}" = "amd64" ]; then DOWNLOAD_ARCH="x64"; fi && \
    curl -sLo ./tailwindcss https://github.com/tailwindlabs/tailwindcss/releases/download/${TAILWIND_VERSION}/tailwindcss-linux-${DOWNLOAD_ARCH}-musl && \
    chmod +x ./tailwindcss

COPY . .

RUN ./tailwindcss -i ./src/input.css -o ./build/output.css --minify

FROM node:22-alpine AS runner

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY --from=tailwind-builder /app/build/output.css ./public/output.css

COPY . .

EXPOSE 80

CMD [ "npm", "start" ]