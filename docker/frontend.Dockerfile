# Build the Flutter web bundle and serve it via Nginx.
ARG FLUTTER_VERSION=beta
ARG BASE_URL=http://localhost:8080

FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build
WORKDIR /app
COPY app/frontend/ .
RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs
RUN flutter build web --release --dart-define=BASE_URL=${BASE_URL} --dart-define=FLAVOR=docker

FROM nginx:1.27-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
