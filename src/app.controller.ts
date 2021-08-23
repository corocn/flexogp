import { Controller, Get, Header, Res, Response, StreamableFile } from '@nestjs/common';
import { AppService } from './app.service';
import { createReadStream } from 'fs';
import { join } from 'path';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @Header('Content-Type', 'image/png')
  async getFile() {
    const file = await this.appService.getFile();
    return new StreamableFile(file);
  }
}
