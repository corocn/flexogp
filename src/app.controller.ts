import { Controller, Get, Header, StreamableFile, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/api/image')
  @Header('Content-Type', 'image/png')
  async getFile(@Query() query: { text: string }) {
    const stream = await this.appService.createImage(query.text);
    return new StreamableFile(stream);
  }

  @Get()
  index() {
    return "hi"
  }
}
