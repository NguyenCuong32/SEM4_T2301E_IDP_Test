import 'package:dart_asm/models/subjects.dart';

class Student {
  final int id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    var subjectsFromJson = json['subjects'] as List<dynamic>;
    List<Subject> subjects = subjectsFromJson.map((subject) => Subject.fromJson(subject)).toList();

    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      subjects: subjects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }

  void updateName(String newName) {
    name = newName;
  }

  void updateSubjects(List<Subject> newSubjects) {
    subjects = newSubjects;
  }
}
