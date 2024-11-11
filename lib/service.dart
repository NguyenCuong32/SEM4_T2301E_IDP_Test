import 'dart:convert';
import 'package:demo_test/student.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Student>> loadStudents() async {
  String jsonString = await rootBundle.loadString('assets/student.json');
  Map<String, dynamic> jsonResponse = json.decode(jsonString);
  List<Student> students = (jsonResponse['students'] as List)
      .map((studentJson) => Student.fromJson(studentJson))
      .toList();
  return students;
}
