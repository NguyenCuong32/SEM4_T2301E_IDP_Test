import 'dart:convert';
import 'dart:io';

import 'Student.dart';
import 'Subject.dart';

class StudentManager {
  List<Student> students = [];

  Future<void> loadFromFile() async {
    final file = File('Student.json');
    if (await file.exists()) {
      final data = jsonDecode(await file.readAsString());
      students = (data['students'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList();
    }
  }
  void deleteStudent(int id) {
    final studentIndex = students.indexWhere((student) => student.id == id);
    if (studentIndex != -1) {
      students.removeAt(studentIndex);
      print('Student with ID $id has been deleted.');
    } else {
      print('Student with ID $id not found.');
    }
  }

  Future<void> saveToFile() async {
    final file = File('Student.json');
    final data = jsonEncode({'students': students.map((student) => student.toJson()).toList()});
    await file.writeAsString(data);
  }

  void displayAllStudents() {
    for (var student in students) {
      print('ID: ${student.id}, Name: ${student.name}');
      for (var subject in student.subjects) {
        print('  Subject: ${subject.name}, Scores: ${subject.scores}');
      }
    }
  }

  void addStudent(int id, String name, List<Subject> subjects) {
    students.add(Student(id, name, subjects));
  }

  void editStudent(int id, {String? name, List<Subject>? subjects}) {
    final student = students.firstWhere((s) => s.id == id, orElse: () => throw Exception('Student not found'));
    if (name != null) {
      student.name = name;
    }
    if (subjects != null) {
      student.subjects = subjects;
    }
  }

  void searchStudent({int? id, String? name}) {
    final foundStudents = students.where((student) =>
    (id != null && student.id == id) || (name != null && student.name.toLowerCase().contains(name.toLowerCase())));
    for (var student in foundStudents) {
      print('ID: ${student.id}, Name: ${student.name}');
      for (var subject in student.subjects) {
        print('  Subject: ${subject.name}, Scores: ${subject.scores}');
      }
    }
  }

  Future<void> showMenu() async {
    while (true) {
      print('\nOptions:');
      print('1. Display all students');
      print('2. Add a new student');
      print('3. Edit a student');
      print('4. Search for a student');
      print('5. Delete a student');  // New delete option
      print('6. Exit');
      stdout.write('Select an option: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          displayAllStudents();
          break;
        case '2':
          await addNewStudent();
          break;
        case '3':
          await editStudentDetails();
          break;
        case '4':
          await searchForStudent();
          break;
        case '5':
          await deleteStudentDetails();  // Calls the delete functionality
          break;
        case '6':
          await saveToFile();
          print('Done. Exiting!');
          return;
        default:
          print('Invalid option. Please choose again.');
      }
    }
  }

  Future<void> deleteStudentDetails() async {
    stdout.write('Enter student ID to delete: ');
    final id = int.parse(stdin.readLineSync()!);
    deleteStudent(id);
    await saveToFile();
  }

  Future<void> addNewStudent() async {
    stdout.write('Enter ID: ');
    final id = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Name: ');
    final name = stdin.readLineSync()!;

    List<Subject> subjects = [];
    while (true) {
      stdout.write('Enter subject name (or enter "oke" to finish): ');
      final subjectName = stdin.readLineSync()!;
      if (subjectName.toLowerCase() == 'oke') break;

      List<int> scores = [];
      while (true) {
        stdout.write('Enter score (or enter -0 to finish): ');
        final score = int.parse(stdin.readLineSync()!);
        if (score == -0) break;
        scores.add(score);
      }
      subjects.add(Subject(subjectName, scores));
    }

    addStudent(id, name, subjects);
    await saveToFile();
    print('Student added successfully!');
  }

  Future<void> editStudentDetails() async {
    stdout.write('Enter student ID to edit details: ');
    final id = int.parse(stdin.readLineSync()!);

    stdout.write('Enter new name (or leave blank to keep current): ');
    final name = stdin.readLineSync();
    List<Subject>? subjects;

    stdout.write('Do you want to edit subjects? (y/n): ');
    if (stdin.readLineSync()!.toLowerCase() == 'y') {
      subjects = [];
      while (true) {
        stdout.write('Enter subject name (or enter "oke" to finish): ');
        final subjectName = stdin.readLineSync()!;
        if (subjectName.toLowerCase() == 'oke') break;

        List<int> scores = [];
        while (true) {
          stdout.write('Enter subject score (or enter "-0" to finish): ');
          final score = int.parse(stdin.readLineSync()!);
          if (score == -0) break;
          scores.add(score);
        }
        subjects.add(Subject(subjectName, scores));
      }
    }

    try {
      editStudent(id, name: name?.isEmpty == true ? null : name, subjects: subjects);
      await saveToFile();
      print('Student information updated successfully!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> searchForStudent() async {
    stdout.write('Enter 1 to search by ID or 2 to search by name: ');
    final choice = stdin.readLineSync();

    if (choice == '1') {
      stdout.write('Enter ID: ');
      final id = int.parse(stdin.readLineSync()!);
      searchStudent(id: id);
    } else if (choice == '2') {
      stdout.write('Enter name: ');
      final name = stdin.readLineSync()!;
      searchStudent(name: name);
    } else {
      print('Invalid selection.');
    }
  }
}
