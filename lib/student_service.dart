import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class StudentService {
  static const String fileName = "Student.json";

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<Map<String, dynamic>>> loadStudents() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      String contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(json.decode(contents)['students']);
    } else {
      String jsonData = await rootBundle.loadString('assets/data/Student.json');
      Map<String, dynamic> jsonList = json.decode(jsonData);
      List<Map<String, dynamic>> students =
          List<Map<String, dynamic>>.from(jsonList['students']);
      await saveStudents(students);
      return students;
    }
  }

  Future<void> saveStudents(List<Map<String, dynamic>> students) async {
    final file = await _getLocalFile();
    String jsonData = json.encode({'students': students});
    await file.writeAsString(jsonData);
  }
}
