FROM node:14-buster-slim AS build

WORKDIR /app
COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . .
RUN npm run build


FROM node:14-buster-slim AS runtime

# RUN apk --no-cache -U upgrade
RUN mkdir -p /app/.ts-node && chown -R node:node /app
WORKDIR /app

COPY package*.json ./
USER node

RUN npm install --only=production
COPY --chown=node:node --from=build /app/MRA_v1.3.0 ./MRA_v1.3.0
COPY --chown=node:node --from=build /app/MRA_custom ./MRA_custom
COPY --chown=node:node --from=build /app/views ./views
COPY --chown=node:node --from=build /app/public ./public
COPY --chown=node:node --from=build /app/.ts-node ./.ts-node
COPY --chown=node:node --from=build /app/LICENSE /app/buildinfo* ./

EXPOSE 3000

ENTRYPOINT ["npm", "run", "start:built"]

