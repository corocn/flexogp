import { Injectable } from '@nestjs/common';
import * as puppeteer from 'puppeteer';
import * as fs from 'fs';
import handlebars from 'handlebars';
import { Duplex } from 'stream';

const bufferToStream = (myBuffer) => {
  const tmp = new Duplex();
  tmp.push(myBuffer);
  tmp.push(null);
  return tmp;
};

@Injectable()
export class AppService {
  async createImage(text: string, layoutName = 'default') {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.setViewport({ width: 1200, height: 630 });

    const layoutFileName = `src/templates/${layoutName}.html.hbs`;
    const hbsFile = fs.readFileSync(layoutFileName, 'utf8');

    const template = handlebars.compile(hbsFile);
    const html = template({ title: text });

    page.setContent(html);
    await page.waitForNavigation({ waitUntil: 'networkidle0' });
    await page.evaluateHandle('document.fonts.ready');
    const buffer = await page.screenshot();
    await browser.close();

    return bufferToStream(buffer);
  }
}
