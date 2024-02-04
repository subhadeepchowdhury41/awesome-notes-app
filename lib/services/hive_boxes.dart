import 'package:demo_frontend/models/auth_model.dart';
import 'package:demo_frontend/models/note_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  static const String notes = 'notes';
  // static const String settings = 'settings';
  static const String auth = 'auth';

  static registerAdapters() {
    Hive.registerAdapter(NoteAdapter());
    // Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(AuthAdapter());
  }

  static openBoxes() async {
    await Hive.openBox<Note>(notes);
    // await Hive.openBox<Settings>(settings);
    await Hive.openBox<Auth>(auth);
  }

  static Box<Note> getNotesBox() => Hive.box<Note>(notes);
  // static Box getSettingsBox() => Hive.box(settings);
  static Box<Auth> getAuthBox() => Hive.box<Auth>(auth);

  static closeBoxes() {
    Hive.close();
  }
}