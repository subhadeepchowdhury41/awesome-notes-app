import 'package:demo_frontend/providers/notes_provider.dart';
import 'package:demo_frontend/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class NoteEdit extends ConsumerStatefulWidget {
  const NoteEdit({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteEditState();
}

class _NoteEditState extends ConsumerState<NoteEdit> {
  final titleController = TextEditingController();
  final contentController = HtmlEditorController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final initData =
        ref.read(notesProvider).firstWhere((note) => note.id == widget.id);
    titleController.text = initData.title!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final note =
        ref.watch(notesProvider).firstWhere((note) => note.id == widget.id);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(note.title!),
            const Text(' (edit)',
                style:
                    TextStyle(fontSize: 17, color: AppConstants.disabledColor))
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppConstants.normalSpacing),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppConstants.primaryColor),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')));
            }
            final content = await contentController.getText();
            ref
                .read(notesProvider.notifier)
                .update(
                    id: widget.id,
                    title: titleController.text,
                    content: content)
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Note updated'),
              ));
              Navigator.of(context).pop();
            });
          },
          child: const Text('Save'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.normalSpacing),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: UnderlineInputBorder(),
                  ),
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
                  controller: contentController,
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: 'Content',
                  ),
                  callbacks: Callbacks(onInit: () {
                    contentController.setText(note.content!);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
