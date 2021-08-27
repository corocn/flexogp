FROM alpine:edge

# Installs latest Chromium (89) package.
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      yarn

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Puppeteer v6.0.0 works with Chromium 89.
RUN yarn add puppeteer@6.0.0

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app /app/dist \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app \
    && chown -R pptruser:pptruser /app/dist

WORKDIR /app
COPY yarn.lock /app/yarn.lock
COPY package.json /app/package.json
RUN yarn install

WORKDIR /app
ENV NODE_ENV=production
COPY . /app
RUN yarn build

# install fonts
RUN wget 'https://fonts.google.com/download?family=Noto+Sans+JP' -O googlefonts.zip \
    && unzip googlefonts.zip -d /usr/share/fonts/googlefonts/ \
    && rm -f googlefonts.zip \
    && fc-cache -fv

# Run everything after as non-privileged user.
USER pptruser

EXPOSE 3000
CMD ["node", "./dist/main.js"]
