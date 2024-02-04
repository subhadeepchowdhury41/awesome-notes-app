import 'dart:developer';

import 'package:demo_frontend/models/note_model.dart';
import 'package:demo_frontend/services/hive_boxes.dart';
import 'package:demo_frontend/services/rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  String? _userId;

  void setUserId(String? value) {
    if (value == null) return;
    _userId = value;
    init();
    refresh();
  }

  init() {
    if (_userId == null) return;
    log('Listening to changes in notes box');
    HiveBoxes.getNotesBox().listenable().addListener(() {
      log('Change in notes box');
      // state = HiveBoxes.getNotesBox().values.toList();
    });
  }

  refresh() async {
    if (_userId == null) return;
    await RestClient.get('note/$_userId', includeAuthTokens: true).then((res) {
      if (res?.statusCode == 200) {
        final notes = res?.data.map<Note>((e) => Note.fromMap(e)).toList();
        if (notes == null) {
          throw Exception('Invalid notes');
        }
        HiveBoxes.getNotesBox().clear();
        HiveBoxes.getNotesBox().addAll(notes);
        state = notes;
      }
    });
  }

  Future<void> create(String title, String content) async {
    await RestClient.post(
            'note',
            {
              'title': title,
              'content': content,
              'userId': _userId,
            },
            includeAuthTokens: true)
        .then((res) {
      if (res?.statusCode == 201) {
        if (res == null) {
          throw Exception('Invalid note');
        }
        refresh();
      }
    });
  }

  Future<void> update({
    required String id,
    required String title,
    required String content,
  }) async {
    await RestClient.patch(
            'note/$id',
            {
              'title': title,
              'content': content,
              'userId': _userId,
            },
            includeAuthTokens: true)
        .then((res) {
      if (res?.statusCode == 200) {
        if (res == null) {
          throw Exception('Invalid note');
        }
        refresh();
      }
    });
  }

  Future<void> delete(String id) async {
    await RestClient.delete('note/$id', includeAuthTokens: true).then((res) {
      if (res?.statusCode == 200) {
        if (res == null) {
          throw Exception('Invalid note');
        }
        refresh();
      }
    });
  }

  void add(Note note) {
    state = [...state, note];
  }

  void remove(Note note) {
    state = state.where((element) => element != note).toList();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);
