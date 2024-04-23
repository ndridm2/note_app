import 'package:flutter/material.dart';
import 'package:note_app/data/datasources/local_datasource.dart';

import '../data/models/note.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Color> colors = [
    Colors.lightBlue.shade700,
    Colors.redAccent.shade700,
    Colors.lightGreen.shade700,
    Colors.pinkAccent.shade700,
    Colors.deepPurpleAccent
  ];

  List<Note> notes = [];
  final searchController = TextEditingController();

  bool isLoading = false;

  void searchNotes(String keyword) async {
    setState(() {
      isLoading = true;
    });
    try {
      notes = await LocalDatasource().searchTitle(keyword);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black54),
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  hintText: 'Search Note',
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  )),
              onChanged: (keyword) => searchNotes(keyword),
              onSubmitted: (keyword) {
                setState(() => isLoading = true);
                searchNotes(keyword);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    value: 0.0,
                    strokeWidth: 10.0,
                    backgroundColor: Colors.blue,
                    color: Colors.blue,
                  ))
                : notes.isEmpty
                    ? Center(child: Image.asset('assets/searchimg.png', width: 200,height: 200,))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
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
                                color: colors[index % colors.length],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.notes, size: 32),
                                        const SizedBox(height: 6),
                                        Text(
                                          notes[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(color: Colors.white),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          notes[index].content,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
