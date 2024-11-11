import 'package:flutter/material.dart';
import 'package:studentmanagement/models/student.dart';
import 'package:studentmanagement/models/subject.dart';
import 'package:studentmanagement/utils/json_helper.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  List<Subject> _subjects = [];

  void _addSubject() {
    setState(() {
      _subjects.add(Subject(name: '', scores: []));
    });
  }

  void _saveStudent() {
    final student = Student(
      id: int.parse(_idController.text),
      name: _nameController.text,
      subjects: _subjects,
    );
    JsonHelper.loadStudents().then((students) {
      students.add(student);
      JsonHelper.saveStudents(students).then((_) {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text('Add Subject'),
            ),
            ElevatedButton(
              onPressed: _saveStudent,
              child: Text('Save Student'),
            ),
          ],
        ),
      ),
    );
  }
}