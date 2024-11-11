import 'dart:convert';
import 'dart:io';

import 'student.dart';
import 'subject.dart';

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

  Future<void> saveToFile() async {
    final file = File('Student.json');
    final data = jsonEncode(
        {'students': students.map((student) => student.toJson()).toList()});
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
    final student = students.firstWhere((s) => s.id == id,
        orElse: () => throw Exception('ko tìm thấy hs'));
    if (name != null) {
      student.name = name;
    }
    if (subjects != null) {
      student.subjects = subjects;
    }
  }

  void searchStudent({int? id, String? name}) {
    final foundStudents = students.where((student) =>
        (id != null && student.id == id) ||
        (name != null &&
            student.name.toLowerCase().contains(name.toLowerCase())));
    for (var student in foundStudents) {
      print('ID: ${student.id}, Name: ${student.name}');
      for (var subject in student.subjects) {
        print('  Subject: ${subject.name}, Scores: ${subject.scores}');
      }
    }
  }

  Future<void> showMenu() async {
    while (true) {
      
      print('1. Hiển thị danh sách hs');
      print('2. Thêm hs mới');
      print('3. Sửa hs');
      stdout.write('Chọn chức năng: ');
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
          await saveToFile();
          print('Đã xong. Thoát!');
          return;
        default:
          print('Không hợp lệ. Chọn lại.');
      }
    }
  }

  Future<void> addNewStudent() async {
    stdout.write('Nhập ID: ');
    final id = int.parse(stdin.readLineSync()!);
    stdout.write('Nhập Name: ');
    final name = stdin.readLineSync()!;

    List<Subject> subjects = [];
    while (true) {
      stdout.write('Nhập tên subject (hoặc nhập "done" để end): ');
      final subjectName = stdin.readLineSync()!;
      if (subjectName.toLowerCase() == 'done') break;

      List<int> scores = [];
      while (true) {
        stdout.write('Nhập điểm (hoặc nhập -1 để end ): ');
        final score = int.parse(stdin.readLineSync()!);
        if (score == -1) break;
        scores.add(score);
      }
      subjects.add(Subject(subjectName, scores));
    }

    addStudent(id, name, subjects);
    await saveToFile();
    print('Thêm hs thành công!');
  }

  Future<void> editStudentDetails() async {
    stdout.write('Nhập id hs để sửa thông tin: ');
    final id = int.parse(stdin.readLineSync()!);

    stdout.write('Nhập tên mới (hoặc bỏ trống để giữ nguyên): ');
    final name = stdin.readLineSync();
    List<Subject>? subjects;

    stdout.write('Có chỉnh sửa subject hay ko ? (y/n): ');
    if (stdin.readLineSync()!.toLowerCase() == 'y') {
      subjects = [];
      while (true) {
        stdout.write('Nhập tên subject (hoặc nhập "done" để end): ');
        final subjectName = stdin.readLineSync()!;
        if (subjectName.toLowerCase() == 'done') break;

        List<int> scores = [];
        while (true) {
          stdout.write('Nhập điểm subject (hoặc nhập "-1" để end): ');
          final score = int.parse(stdin.readLineSync()!);
          if (score == -1) break;
          scores.add(score);
        }
        subjects.add(Subject(subjectName, scores));
      }
    }

    try {
      editStudent(id,
          name: name?.isEmpty == true ? null : name, subjects: subjects);
      await saveToFile();
      print('Cập nhật thông tin hs thành công!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> searchForStudent() async {
    stdout.write('Nhập 1 để tìm theo ID hoặc nhập 2 để tìm theo tên ? ');
    final choice = stdin.readLineSync();

    if (choice == '1') {
      stdout.write('Nhập ID: ');
      final id = int.parse(stdin.readLineSync()!);
      searchStudent(id: id);
    } else if (choice == '2') {
      stdout.write('Nhập tên: ');
      final name = stdin.readLineSync()!;
      searchStudent(name: name);
    } else {
      print('Chọn ko hợp lệ.');
    }
  }
}
