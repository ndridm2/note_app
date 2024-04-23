import 'package:flutter/material.dart';
import 'package:note_app/data/datasources/local_datasource.dart';
import 'package:note_app/main.dart';

import 'package:note_app/pages/edit_page.dart';
import 'package:note_app/pages/home_page.dart';
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
        backgroundColor: Colors.white,
        elevation: 0.1,
        leading: const BackButton(color: Colors.black54,),
        actions: [
          PopupMenuButton(
            iconColor: Colors.black54,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Edit',
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit_note,
                      color: Colors.blue,
                    ),
                    Text('Edit')
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return EditPage(note: widget.note);
                    },
                  ));
                },
              ),
              PopupMenuItem<String>(
                value: 'Delete',
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red,
                    ),
                    Text('Delete')
                  ],
                ),
                onTap: () {
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const HomePage();
                              }));
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
                fontFamily: 'Oxygen'),
          ),
          const SizedBox(height: 16),
          Text(
            widget.note.content,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 20, fontFamily: 'Oxygen'),
          ),
        ],
      ),
    );
  }
}
