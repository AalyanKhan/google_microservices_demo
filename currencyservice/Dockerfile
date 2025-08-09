# --- BUILDER STAGE ---
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production && npm cache clean --force

COPY . .

# --- FINAL STAGE ---

FROM gcr.io/distroless/node20-debian12:nonroot


COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

USER 65532

CMD ["node", "index.js"]


