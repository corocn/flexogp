FROM ghcr.io/puppeteer/puppeteer:16.1.0

RUN apt-get update && apt-get install -y unzip

# install fonts
RUN wget 'https://fonts.google.com/download?family=Noto+Sans+JP' -O googlefonts.zip \
    && unzip googlefonts.zip -d /usr/share/fonts/googlefonts/ \
    && rm -f googlefonts.zip \
    && fc-cache -fv

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
