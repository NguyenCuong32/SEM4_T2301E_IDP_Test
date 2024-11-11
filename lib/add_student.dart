
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'studentProvider.dart';
import 'student.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final List<Subject> _subjects = [];
  final _subjectNameController = TextEditingController();
  final _subjectScoreController = TextEditingController();

  void _addSubject() {
    final subjectName = _subjectNameController.text;
    final subjectScore = double.tryParse(_subjectScoreController.text);

    if (subjectName.isNotEmpty && subjectScore != null) {
      setState(() {
        _subjects.add(Subject(name: subjectName, score: subjectScore));
        _subjectNameController.clear();
        _subjectScoreController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Sinh Viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _subjectNameController,
              decoration: InputDecoration(labelText: 'Tên Môn Học'),
            ),
            TextField(
              controller: _subjectScoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Điểm Số'),
            ),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text('Thêm Môn Học'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return ListTile(
                    title: Text(subject.name),
                    subtitle: Text('Điểm: ${subject.score}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final student = Student(
                  id: _idController.text,
                  name: _nameController.text,
                  subjects: _subjects,
                );
                Provider.of<StudentProvider>(context, listen: false).addStudent(student);
                Navigator.pop(context);
              },
              child: Text('Thêm Sinh Viên'),
            ),
          ],
        ),
      ),
    );
  }
}
