import 'package:flutter/material.dart';
import 'package:note_app/data/datasources/local_datasource.dart';
import 'package:note_app/data/models/note.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const BackButton(
          color: Colors.white,
        ),
        titleSpacing: -10,
        title: const Text(
          'Add Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Jersey20',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Note note = Note(
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: DateTime.now(),
                );
                LocalDatasource().insertNote(note);
                titleController.clear();
                contentController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Note successfully saved'),
                  backgroundColor: Colors.blueGrey,
                ));
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Content must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
