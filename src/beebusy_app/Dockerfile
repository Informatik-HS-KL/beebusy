FROM cirrusci/flutter:1.25.0-8.1.pre AS builder

RUN flutter config --enable-web \
    && sudo apt-get update \
    && sudo apt-get install -y chromium-browser \
    && sudo rm -rf /var/lib/apt/lists/*

RUN flutter precache --web --no-android --no-ios --no-linux --no-windows --no-macos --no-fuchsia --no-universal

WORKDIR /app

COPY . .
RUN flutter pub get \
    && flutter packages pub run build_runner build --delete-conflicting-outputs \
    && flutter build web --dart-define=IS_PROD=true


FROM nginx:1.18.0-alpine

ENV API_HOST=server
ENV API_PORT=80

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY ./replaceEnvVars.sh /
RUN chmod +x /replaceEnvVars.sh

EXPOSE 80

ENTRYPOINT ["/replaceEnvVars.sh"]
CMD ["nginx", "-g", "daemon off;"]