import 'package:flutter/material.dart';
import 'package:note_app/data/datasources/local_datasource.dart';
import 'package:note_app/main.dart';

import '../data/models/note.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    super.key,
    required this.note,
  });
  final Note note;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        titleSpacing: -10,
        title: const Text(
          'Edit Note',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Jersey20'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Note note = Note(
                    id: widget.note.id,
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now());
                LocalDatasource().updateNoteById(note);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const MyApp();
                }));
              }
            },
            icon: const Icon(Icons.save_alt, color: Colors.white,),
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
          ],
        ),
      ),
    );
  }
}
