import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/student.dart';

class StudentService {
  Future<List<Student>> loadStudents() async {
    String data = await rootBundle.loadString('assets/students.json');
    List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((e) => Student.fromJson(e)).toList();
  }

  Future<void> saveStudents(List<Student> students) async {
    String jsonString = jsonEncode(students.map((e) => e.toJson()).toList());
  }
}
