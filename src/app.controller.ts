import { Controller, Get, Header, StreamableFile } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @Header('Content-Type', 'image/png')
  async getFile() {
    const file = await this.appService.createImage(
      'あいうえおかきくけこさしすせそ',
    );
    return new StreamableFile(file);
  }
}
