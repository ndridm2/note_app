import 'package:note_app/data/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatasource {
  final String dbName = 'notes_local.db';
  final String tableName = 'notes';

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        '''CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            createdAt TEXT)''',
      );
    });
  }

  //insert data
  Future<int> insertNote(Note note) async {
    final db = await _openDatabase();
    return await db.insert(tableName, note.toMap());
  }

  //get data
  Future<List<Note>> getNotes() async {
    final db = await _openDatabase();
    final maps = await db.query(tableName, orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  //get by id
  Future<Note> getNoteById(int id) async {
    final db = await _openDatabase();
    final maps = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return Note.fromMap(maps.first);
  }

  //search by title
  Future<List<Note>> searchTitle(String query) async {
    // ignore: unused_local_variable
    final db = await _openDatabase();
    List<Note> list = await getNotes();
    return list.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  //update data
  Future<int> updateNoteById(Note note) async {
    final db = await _openDatabase();
    return await db
        .update(tableName, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  //delete data
  Future<int> deleteNoteById(int id) async {
    final db = await _openDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
