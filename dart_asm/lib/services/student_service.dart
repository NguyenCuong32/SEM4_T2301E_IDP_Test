import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/students.dart';

class StudentService {

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/Student.json');
  }

  Future<void> _copyAssetToLocal() async {
    final file = await _getLocalFile();
    if (!(await file.exists())) {
      final data = await rootBundle.loadString('assets/Student.json');
      await file.writeAsString(data);
    }
  }

  Future<void> initialize() async {
    await _copyAssetToLocal();
  }

  Future<List<Student>> getAllStudents() async {
    await initialize();
    final file = await _getLocalFile();
    final data = await file.readAsString();

    final jsonData = json.decode(data);

    if (jsonData is Map<String, dynamic>) {
      final studentsData = jsonData['students'];
      return studentsData.map<Student>((json) => Student.fromJson(json)).toList();
    }
    else if (jsonData is List) {
      return jsonData.map<Student>((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception("Invalid JSON format");
    }
  }

  Future<void> addStudent(Student student) async {
    final students = await getAllStudents();
    students.add(student);
    await _saveStudents(students);
  }

  Future<void> updateStudent(Student student) async {
    final students = await getAllStudents();
    final index = students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      students[index] = student;
      await _saveStudents(students);
    }
  }

  Future<void> _saveStudents(List<Student> students) async {
    final file = await _getLocalFile();
    final jsonData = students.map((student) => student.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  Future<Student?> searchStudent(String query) async {
    final students = await getAllStudents();
    try {
      return students.firstWhere(
            (student) => student.name.contains(query) || student.id.toString() == query,
      );
    } catch (e) {
      return null;
    }
  }
}
