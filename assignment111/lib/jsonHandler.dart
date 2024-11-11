

import 'dart:convert';
import 'dart:io';

import 'package:assignment111/student.dart';

class JsonHandler {
  static List<Student> loadStudents(String path) {
    var file = File(path);
    if (file.existsSync()) {
      var content = file.readAsStringSync();
      List<dynamic> jsonData = json.decode(content);
      return jsonData.map((data) => Student.fromJson(data)).toList();
    }
    return [];
  }

  static void saveStudents(String path, List<Student> students) {
    var file = File(path);
    String jsonData = json.encode(students.map((student) => student.toJson()).toList());
    file.writeAsStringSync(jsonData);
  }
}
