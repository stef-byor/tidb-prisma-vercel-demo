FROM node:18-alpine as builder
RUN npm install -g pnpm
RUN apk --no-cache add openssl
WORKDIR /app        
COPY . .

ENV npm_config_cache=/app

RUN if [ -f "./package-lock.json" ]; then npm install; \
    elif [ -f "./yarn.lock" ]; then yarn; \           
    elif [ -f "./pnpm-lock.yaml" ]; then pnpm install; fi

COPY . .

# Install Prisma CLI globally
RUN npm install -g @prisma/cli

# Debugging: List contents before and after code generation
RUN ls -la
RUN npx prisma generate
RUN ls -la

RUN npm run build

RUN chown -R 10500:10500 "/app"

USER 10500

EXPOSE 3000

CMD [ "npm", "start" ]
