import 'package:flutter/material.dart';

import '../models/students.dart';
import '../models/subjects.dart';
import '../services/student_service.dart';

class StudentEditScreen extends StatefulWidget {
  final Student student;

  const StudentEditScreen({Key? key, required this.student}) : super(key: key);

  @override
  _StudentEditScreenState createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends State<StudentEditScreen> {
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final StudentService _studentService = StudentService();

  late Student _student;
  late List<Subject> _subjects;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
    _subjects = List.from(_student.subjects);
    _nameController.text = _student.name;
  }

  void _addSubject() {
    final input = _subjectController.text.split(':');

    if (input.length == 2) {
      final subjectName = input[0].trim();
      final scoresString = input[1].trim();

      if (scoresString.isNotEmpty) {
        final scores = scoresString.split(',')
            .map((score) => score.trim())
            .map((score) => int.tryParse(score))
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
          SnackBar(content: Text("Please enter scores separated by commas.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid format. Please use 'Subject: score1, score2, score3'.")),
      );
    }
  }


  void _updateStudent() async {
    // Update student's name and subjects
    _student.name = _nameController.text;
    _student.subjects = _subjects;

    // Save updated student
    await _studentService.updateStudent(_student);

    // Pop the screen and return to the previous one
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject and Score (e.g., Math:90)'),
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
                  onDeleted: () {
                    setState(() {
                      _subjects.remove(subject);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateStudent,
              child: Text('Update Student'),
            ),
          ],
        ),
      ),
    );
  }
}
