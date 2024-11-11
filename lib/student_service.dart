import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'student.dart';

class StudentService {
  Future<List<Student>> getStudents() async {
    final file = await _getLocalFile();
    if (!await file.exists()) return [];
    final contents = await file.readAsString();
    final List data = jsonDecode(contents);
    return data.map((e) => Student.fromJson(e)).toList();
  }

  Future<void> saveStudents(List<Student> students) async {
    final file = await _getLocalFile();
    final data = jsonEncode(students.map((e) => e.toJson()).toList());
    await file.writeAsString(data);
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/Student.json');
  }
}
