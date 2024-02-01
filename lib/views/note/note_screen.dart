
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteScreen extends ConsumerStatefulWidget {
  final String id;
  const NoteScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}