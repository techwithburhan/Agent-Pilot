# =========================
# Stage 1: Build Stage
# =========================
FROM node:18-alpine AS builder  
# 👉 Lightweight Node.js image (alpine = small size)

WORKDIR /app  
# 👉 Container ke andar working directory set kar rahe hain

COPY package*.json ./  
# 👉 package.json aur package-lock.json copy kar rahe hain (dependency install ke liye)

RUN npm install --only=production  
# 👉 Sirf production dependencies install kar rahe hain (size optimize)

# =========================
# Stage 2: Production Stage
# =========================
FROM node:18-alpine  
# 👉 Final runtime ke liye fresh clean image (best practice)

WORKDIR /app  
# 👉 Again working directory set

COPY --from=builder /app/node_modules ./node_modules  
# 👉 Builder stage se installed dependencies copy kar li

COPY . .  
# 👉 Baaki project files copy kar diye (server.js etc.)

# =========================
# Environment Variables
# =========================
ENV PORT=5005  
# 👉 Default port set (can override via docker run)

EXPOSE 5005  
# 👉 Docker ko batate hain ki app kaunsa port use karega

# =========================
# Start Command
# =========================
CMD ["node", "server.js"]  
# 👉 Container start hote hi backend run karega
