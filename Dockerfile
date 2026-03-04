FROM node:20-slim

WORKDIR /usr/src/app

# Install prod dependencies deterministically
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Copy only what you need at runtime
COPY dist/ ./dist/
COPY server.js ./

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

# Drop root privileges
USER node

CMD ["node", "server.js"]