import 'dart:convert';

class Subject {
  String name;
  List<int> scores;

  Subject(this.name, this.scores);

  Map<String, dynamic> toJson() => {
    'name': name,
    'scores': scores,
  };

  static Subject fromJson(Map<String, dynamic> json) {
    return Subject(json['name'], List<int>.from(json['scores']));
  }
}
