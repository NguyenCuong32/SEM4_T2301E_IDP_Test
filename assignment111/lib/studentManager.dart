import 'package:assignment111/jsonHandler.dart';
import 'package:assignment111/student.dart';

class StudentManager {
  List<Student> students = [];

  void loadStudents(String path) {
    students = JsonHandler.loadStudents(path);
  }

  void saveStudents(String path) {
    JsonHandler.saveStudents(path, students);
  }

  void displayStudents() {
    for (var student in students) {
      print('ID: ${student.id}, Name: ${student.name}');
      student.subjects.forEach((subject, scores) {
        print('  Subject: $subject, Scores: $scores');
      });
    }
  }

  void addStudent(Student student) {
    students.add(student);
  }

  void editStudent(String id, {String? newName, Map<String, List<int>>? newSubjects}) {
    for (var student in students) {
      if (student.id == id) {
        if (newName != null) student.name = newName;
        if (newSubjects != null) student.subjects = newSubjects;
        break;
      }
    }
  }

  Student? searchStudent(String query) {
  try {
    return students.firstWhere(
        (student) => student.name.contains(query) || student.id.contains(query));
  } catch (e) {
    return null;
  }
}

}
