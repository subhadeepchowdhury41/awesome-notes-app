import 'package:demo_frontend/providers/notes_provider.dart';
import 'package:demo_frontend/utils/consts.dart';
import 'package:demo_frontend/views/notes/note_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class NoteScreen extends ConsumerStatefulWidget {
  final String id;
  const NoteScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  final _controller = HtmlEditorController();
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    final note =
        ref.watch(notesProvider).firstWhere((note) => note.id == widget.id);
    if (loaded) {
      _controller.setText(note.content!);
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: AppConstants.primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteEdit(
                    id: widget.id,
                  )));
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        title: Text(note.title!),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Note'),
                      content: const Text(
                          'Are you sure you want to delete this note?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: AppConstants.errorColor),
                          onPressed: () {
                            ref
                                .read(notesProvider.notifier)
                                .delete(widget.id)
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Note deleted'),
                              ));
                            });
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  }).then((value) {
                if (value == true) {
                  Navigator.of(context).pop();
                }
              });
            },
            icon: const Icon(
              Icons.delete,
              color: AppConstants.errorColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.normalSpacing),
              child: HtmlEditor(
                htmlEditorOptions:
                    const HtmlEditorOptions(hint: 'Content', disabled: true),
                controller: _controller,
                callbacks: Callbacks(onInit: () {
                  loaded = true;
                  _controller.setText(note.content!);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
