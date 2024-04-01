import 'package:flutter/material.dart';
import 'package:note_app/data/datasources/local_datasource.dart';
import 'package:note_app/main.dart';

import 'package:note_app/pages/edit_page.dart';
import '../data/models/note.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete note'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await LocalDatasource()
                              .deleteNoteById(widget.note.id!);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return const MyApp();
                          }));
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.note.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.note.content,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return EditPage(note: widget.note);
            },
          ));
        },
        backgroundColor: Colors.white,
        splashColor: Colors.blue,
        child: const Icon(
          Icons.edit,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
