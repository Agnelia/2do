# Multi-stage Docker build for Flutter web app

# Stage 1: Build the Flutter web app
FROM cirrusci/flutter:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build web app
RUN flutter build web --release

# Stage 2: Serve the app with nginx
FROM nginx:alpine

# Copy built web app from previous stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Handle client-side routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]