FROM node:16

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update \
    && apt-get install -y wget gnupg unzip \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/pptruser

COPY puppeteer-latest.tgz /home/pptruser/puppeteer-latest.tgz

# Install puppeteer into /home/pptruser/node_modules.
RUN npm i ./puppeteer-latest.tgz \
    && rm puppeteer-latest.tgz \
    # Add user so we don't need --no-sandbox.
    # same layer as npm install to keep re-chowned files from using up several hundred MBs more space
    && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && (node -e "require('child_process').execSync(require('puppeteer').executablePath() + ' --credits', {stdio: 'inherit'})" > THIRD_PARTY_NOTICES)

USER pptruser


# ここまで https://github.com/puppeteer/puppeteer/blob/main/docker/Dockerfile ベース

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
