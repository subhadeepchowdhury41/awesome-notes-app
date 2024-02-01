import 'package:demo_frontend/models/note_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  init() async {
    
  }

  void add(Note note) {
    state = [...state, note];
  }

  void remove(Note note) {
    state = state.where((element) => element != note).toList();
  }

  void update(Note note) {
    state = state.map((element) => element == note ? note : element).toList();
  }
}