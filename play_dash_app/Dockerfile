# Stage 1: Build the Flutter Web app
FROM ghcr.io/cirruslabs/flutter:3.22.0 AS build

WORKDIR /app
COPY . .

# Install dependencies and run code generation
RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Build for WebAssembly
RUN flutter build web --wasm

# Stage 2: Serve with Nginx (Production Ready)
FROM nginx:alpine

# Copy built assets from the build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Cloudflare Tunnel expects port 8000 based on your current config
# We create a custom nginx config to listen on 8000 and handle SPA routing
RUN echo 'server { \
    listen 8000; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]