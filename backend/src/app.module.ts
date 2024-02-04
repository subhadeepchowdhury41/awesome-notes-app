import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UsersModule } from './users/users.module';
import { NoteModule } from './notes/note.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://localhost/nestjs'),
    UsersModule,
    NoteModule,
    AuthModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
