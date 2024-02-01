import 'package:hive/hive.dart';

class HiveBoxes {
  static const String notes = 'notes';
  static const String settings = 'settings';
  static const String auth = 'auth';

  static openBoxes() async {
    await Hive.openBox(notes);
    await Hive.openBox(settings);
    await Hive.openBox(auth);
  }

  static Box getNotesBox() => Hive.box(notes);
  static Box getSettingsBox() => Hive.box(settings);
  static Box getAuthBox() => Hive.box(auth);
}