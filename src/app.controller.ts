import { Controller, Get, Header, StreamableFile } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @Header('Content-Type', 'image/png')
  async getFile() {
    const stream = await this.appService.createImage(
      'Next.jsとesaを使った個人サイト構築',
    );
    return new StreamableFile(stream);
  }
}
