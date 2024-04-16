import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/data/datasources/local_datasource.dart';
import 'package:note_app/pages/add_page.dart';
import 'package:note_app/pages/detail_page.dart';
import 'package:note_app/pages/search_page.dart';

import '../data/models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  bool isLoading = false;

  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await LocalDatasource().getNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Note App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Jersey20',
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SearchPage();
              }));
            },
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.search,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              value: 0.0,
              strokeWidth: 10.0,
              backgroundColor: Colors.grey,
              color: Colors.blue,
            ))
          : notes.isEmpty
              ? const Center(child: Text('No Notes'))
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailPage(note: notes[index]);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.notes,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        DateFormat(
                                                DateFormat.YEAR_NUM_MONTH_DAY)
                                            .format(notes[index].createdAt),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'jersey20',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notes[index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontFamily: 'Oxygen'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notes[index].content,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontFamily: 'Oxygen'),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: notes.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPage();
          }));
          getNotes();
        },
        backgroundColor: Colors.white,
        splashColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.blue,
        ),
      ),
    );
  }
}
