import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/student.dart';

class StudentService {
  static List<Student> _students = [];

  static Future<void> loadStudents() async {
    final data = await rootBundle.loadString('assets/students.json');
    final jsonResult = json.decode(data);
    _students = (jsonResult['students'] as List)
        .map((student) => Student.fromJson(student))
        .toList();
  }

  static List<Student> getStudents() {
    return _students;
  }

  static void addStudent(Student student) {
    student.id = DateTime.now().millisecondsSinceEpoch;
    _students.add(student);
  }

  static void updateStudent(int id, Student updatedStudent) {
    final index = _students.indexWhere((student) => student.id == id);
    if (index != -1) {
      _students[index] = updatedStudent;
    }
  }

  static List<Student> searchStudent(String query) {
    return _students.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.id.toString() == query;
    }).toList();
  }

  static void clearAll() {
    _students.clear();
  }
}
