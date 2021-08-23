import { Injectable } from '@nestjs/common';
import * as puppeteer from 'puppeteer';
import * as fs from 'fs';
import handlebars from 'handlebars';

@Injectable()
export class AppService {
  async getFile() {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.setViewport({ width: 1200, height: 630 });
    const hbsFile = fs.readFileSync('src/templates/default.html.hbs', 'utf8');

    const template = handlebars.compile(hbsFile);
    const html = template({ title: 'これはタイトルですこれはタイトルですこれはタイトルです' });

    page.setContent(html);
    await page.waitForNavigation({ waitUntil: 'networkidle0' });
    await page.evaluateHandle('document.fonts.ready');
    await page.screenshot({ path: './tmp/example.png' });
    await browser.close();

    return fs.createReadStream('./tmp/example.png');
  }
}
