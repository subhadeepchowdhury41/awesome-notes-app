import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteEdit extends ConsumerStatefulWidget {
  const NoteEdit({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteEditState();
}

class _NoteEditState extends ConsumerState<NoteEdit> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}