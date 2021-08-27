FROM buildkite/puppeteer:10.0.0

WORKDIR /app
COPY yarn.lock /app/yarn.lock
COPY package.json /app/package.json
RUN yarn install

WORKDIR /app
ENV NODE_ENV=production
COPY . /app
RUN yarn build

EXPOSE 3000
CMD ["node", "./dist/main.js"]
