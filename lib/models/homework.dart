import 'dart:convert';

class Homework {
  final String id;
  final String subject;
  final String title;
  final DateTime dueDate;
  final bool completed;


  Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.dueDate,
    this.completed = false,
  });


  Homework copyWith({
    String? id,
    String? subject,
    String? title,
    DateTime? dueDate,
    bool? completed,
  }) =>
      Homework(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        completed: completed ?? this.completed,
      );


  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'subject': subject,
        'title': title,
        'dueDate': dueDate.toIso8601String(),
        'completed': completed,
      };


  factory Homework.fromMap(Map<String, dynamic> map) =>
      Homework(
        id: map['id'] as String,
        subject: map['subject'] as String,
        title: map['title'] as String,
        dueDate: DateTime.parse(map['dueDate'] as String),
        completed: map['completed'] as bool? ?? false,
      );


  String toJson() => json.encode(toMap());

  factory Homework.fromJson(String source) =>
      Homework.fromMap(json.decode(source));
}