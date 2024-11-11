class Student {
  String id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    var subjectsFromJson = json['subjects'] as List;
    List<Subject> subjectList = subjectsFromJson.map((i) => Subject.fromJson(i)).toList();

    return Student(
      id: json['id'],
      name: json['name'],
      subjects: subjectList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}

class Subject {
  String name;
  int score;

  Subject({required this.name, required this.score});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
    };
  }
}
