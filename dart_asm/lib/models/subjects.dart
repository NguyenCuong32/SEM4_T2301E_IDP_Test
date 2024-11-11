class Subject {
  final String name;
  final List<int> scores;

  Subject({required this.name, required this.scores});

  factory Subject.fromJson(Map<String, dynamic> json) {

    var scoresFromJson = json['scores'] as List<dynamic>;
    List<int> scores = scoresFromJson.map((score) {
      if (score is int) {
        return score;
      } else {
        throw FormatException("Score must be an integer");
      }
    }).toList();

    return Subject(
      name: json['name'] as String,
      scores: scores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'scores': scores,
    };
  }
}
