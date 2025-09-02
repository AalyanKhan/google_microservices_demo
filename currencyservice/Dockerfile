# --- BUILDER STAGE ---
FROM node:20.18.0-alpine AS builder

RUN apk add --no-cache python3 make g++

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production && npm cache clean --force

COPY . .

# --- FINAL STAGE ---

FROM gcr.io/distroless/nodejs20-debian12:nonroot

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

USER 65532

CMD ["node", "index.js"]


