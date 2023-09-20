FROM node:18
RUN npm install -g pnpm
WORKDIR /app
# Install necessary system dependencies, including OpenSSL
RUN apt-get update && apt-get install -y openssl
COPY . .

ENV npm_config_cache=/app

RUN if [ -f "./package-lock.json" ]; then npm install; \
    elif [ -f "./yarn.lock" ]; then yarn; \           
    elif [ -f "./pnpm-lock.yaml" ]; then pnpm install;fi

COPY . .

# RUN npx eslint src
RUN npx prisma generate
RUN npm run build

RUN chown -R 10500:10500 "/app"

USER 10500

EXPOSE 3000

CMD [ "npm", "start" ]
