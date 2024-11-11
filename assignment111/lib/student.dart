class Student {
  String id;
  String name;
  Map<String, List<int>> subjects;

  Student(this.id, this.name, this.subjects);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subjects': subjects,
      };

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      json['id'],
      json['name'],
      Map<String, List<int>>.from(
          json['subjects'].map((key, value) => MapEntry(key, List<int>.from(value)))),
    );
  }
}
