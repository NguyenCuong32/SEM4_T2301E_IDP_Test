import 'package:demo_test/subject.dart';

class Student {
  int id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    var subjectsList = (json['subjects'] as List)
        .map((subjectJson) => Subject.fromJson(subjectJson))
        .toList();
    return Student(id: json['id'], name: json['name'], subjects: subjectsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}
