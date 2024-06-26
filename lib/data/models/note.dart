import 'dart:convert';

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
  
    return result;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.parse(map['createdAt'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}
