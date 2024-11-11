import 'package:flutter/material.dart';
import 'student.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];

  List<Student> get students => _students;

  // Load students (you can load from an API or a local data source)
  Future<void> loadStudents() async {
    // Simulate loading students with a delay
    await Future.delayed(Duration(seconds: 2));
    _students = [
      Student(id: '1', name: 'Alice', subjects: []),
      Student(id: '2', name: 'Bob', subjects: []),
    ];
    notifyListeners();  // Notify listeners after loading students
  }

  // Add a student
  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();  // Notify listeners after adding a student
  }
}
