import { Injectable } from '@nestjs/common';
import { CreateNoteDto } from './dto/create-note.dto';
import { UpdateNoteDto } from './dto/update-note.dto';
import { Note, NoteDocument } from './schemas/notes.schema';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';

@Injectable()
export class NoteService {
  constructor(
    @InjectModel(Note.name) private readonly noteModel: Model<NoteDocument>,
  ) {}

  async create(createNoteDto: CreateNoteDto) {
    await this.noteModel.create(createNoteDto);
  }

  findAll(userId: string) {
    console.log('userId', userId);
    return this.noteModel.find().where('userId').equals(userId).exec();
  }

  findOne(id: number) {
    return this.noteModel.findById(id);
  }

  update(id: string, updateNoteDto: UpdateNoteDto) {
    return this.noteModel.findByIdAndUpdate(id, updateNoteDto);
  }

  remove(id: string) {
    return this.noteModel.findByIdAndDelete(id);
  }
}
