import 'package:demo_frontend/providers/notes_provider.dart';
import 'package:demo_frontend/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class NoteCreateScreen extends ConsumerStatefulWidget {
  const NoteCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NoteCreateScreenState();
}

class _NoteCreateScreenState extends ConsumerState<NoteCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = HtmlEditorController();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (result) async {
        ref.read(notesProvider.notifier).refresh();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Note'),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(AppConstants.normalSpacing),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppConstants.primaryColor),
            onPressed: () async {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Title is required'),
                ));
                return;
              }
              final content = await _contentController.getText();
              ref
                  .read(notesProvider.notifier)
                  .create(_titleController.text, content)
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Note created'),
                ));
                Navigator.of(context).pop();
              });
            },
            child: const Text('Create'),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(AppConstants.normalSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // TextFormField(
                //   controller: contentController,
                //   decoration: const InputDecoration(
                //     labelText: 'Content',
                //     border: UnderlineInputBorder(),
                //   ),
                // ),
                HtmlEditor(
                  otherOptions: OtherOptions(
                    height: MediaQuery.of(context).size.height * 0.7,
                  ),
                  controller: _contentController,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
