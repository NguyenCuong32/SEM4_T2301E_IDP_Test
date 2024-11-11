import 'package:flutter/material.dart';
import 'student_service.dart';

class StudentProvider with ChangeNotifier {
  List<Map<String, dynamic>> _students = [];
  final StudentService _service = StudentService();

  List<Map<String, dynamic>> get students => _students;

  StudentProvider() {
    loadStudents();
  }

  void loadStudents() async {
    _students = await _service.loadStudents();
    notifyListeners();
  }

  void saveStudents() {
    _service.saveStudents(_students);
    notifyListeners();
  }

  void addStudent(int id, String name, List<Map<String, dynamic>> subjects) {
    final newStudent = {
      'id': id,
      'name': name,
      'subjects': subjects,
    };

    _students.add(newStudent);
    notifyListeners();
  }

  void editStudent(int id, Map<String, dynamic> updatedStudent) {
    int index = _students.indexWhere((student) => student['id'] == id);
    if (index != -1) {
      _students[index] = updatedStudent;
      saveStudents();
    }
  }

  void deleteStudent(int id) {
    _students.removeWhere((student) => student['id'] == id);
    saveStudents();
  }

  List<Map<String, dynamic>> searchStudents(String query) {
    return _students
        .where((student) =>
            student['name'].toLowerCase().contains(query.toLowerCase()) ||
            student['id'].toString() == query)
        .toList();
  }
}
