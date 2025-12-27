# Build Next.js standalone
FROM node:20-alpine AS build
WORKDIR /app

COPY app/frontend/package*.json ./
RUN npm ci

COPY app/frontend/ .

ARG NEXT_PUBLIC_API_URL=http://localhost:8180
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}

RUN npm run build

# Production
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/public ./public

EXPOSE 3000
CMD ["node", "server.js"]
