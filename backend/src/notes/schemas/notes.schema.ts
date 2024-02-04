import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type NoteDocument = Note & Document;

@Schema()
export class Note {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  content: string;

  @Prop({ type: 'ObjectId', ref: 'User', required: true })
  userId: string;
}

export const NoteSchema = SchemaFactory.createForClass(Note);
