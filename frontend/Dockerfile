# ─────────────────────────────────────────
# Stage 1 — BUILD STAGE
# Install dependencies and build React app
# ─────────────────────────────────────────
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first (better layer caching)
# If package.json hasn't changed, npm install won't re-run
COPY package*.json ./

# Install all dependencies
RUN npm install --legacy-peer-deps

# Copy all source code
COPY . .

# Set the backend URL as build arg so it's baked into the React build
ARG REACT_APP_API_URL=http://localhost:5005
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Build the production React app
RUN npm run build

# ─────────────────────────────────────────
# Stage 2 — PRODUCTION STAGE
# Serve built files with Nginx
# Only this stage goes into final image
# ─────────────────────────────────────────
FROM nginx:1.25-alpine AS production

# Remove default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built React files from Stage 1
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
