import 'Subject.dart';

class Student {
  int id;
  String name;
  List<Subject> subjects;

  Student(this.id, this.name, this.subjects);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subjects': subjects.map((subject) => subject.toJson()).toList(),
  };

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      json['id'],
      json['name'],
      (json['subjects'] as List)
          .map((subjectJson) => Subject.fromJson(subjectJson))
          .toList(),
    );
  }
}
