import 'package:flutter/material.dart';
import '../models/students.dart';
import '../models/subjects.dart';
import '../services/student_service.dart';

class StudentAddScreen extends StatefulWidget {
  @override
  _StudentAddScreenState createState() => _StudentAddScreenState();
}

class _StudentAddScreenState extends State<StudentAddScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final StudentService _studentService = StudentService();

  List<Subject> _subjects = [];

  void _addSubject() {
    final input = _subjectController.text.split(':');

    if (input.length == 2) {
      final subjectName = input[0].trim();
      final scoresString = input[1].trim();

      final scores = scoresString.split(',')
          .map((score) => int.tryParse(score.trim()))
          .where((score) => score != null)
          .map((score) => score!)
          .toList();

      if (scores.isNotEmpty) {
        setState(() {
          _subjects.add(Subject(name: subjectName, scores: scores));
        });
        _subjectController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter valid scores separated by commas.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid format. Please use 'Subject: score1, score2, score3'.")),
      );
    }
  }

  void _addStudent() async {
    final id = _idController.text;
    final name = _nameController.text;

    final student = Student(id: int.parse(id), name: name, subjects: _subjects);

    await _studentService.addStudent(student);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Student ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject and Score (e.g., Math: 9, 8, 8)'),
            ),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text('Add Subject'),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              children: _subjects.map((subject) {
                return Chip(
                  label: Text('${subject.name}: ${subject.scores.join(", ")}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStudent,
              child: Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}
