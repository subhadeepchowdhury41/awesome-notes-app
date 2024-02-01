import 'dart:developer';

import 'package:demo_frontend/models/note_model.dart';
import 'package:demo_frontend/services/hive_boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  init() {
    log('Listening to changes in notes box');
    HiveBoxes.getNotesBox().listenable().addListener(() {
      state = HiveBoxes.getNotesBox().values.toList();
    });
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

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);
