import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  // Pass the student if editing, otherwise null for adding a new student
  StudentFormScreen({this.student});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  List<Subject> _subjects = [];

  // Controller to keep track of the current subject and scores
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  List<int> _scores = [];

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      // Pre-fill the form fields if editing
      _name = widget.student!.name;
      _subjects = List.from(widget.student!.subjects);
    }
  }

  void _addScore() {
    if (_scoreController.text.isNotEmpty) {
      setState(() {
        _scores.add(int.parse(_scoreController.text));
        _scoreController.clear();
      });
    }
  }

  void _addSubject() {
    if (_subjectController.text.isNotEmpty && _scores.isNotEmpty) {
      setState(() {
        _subjects.add(
            Subject(name: _subjectController.text, scores: List.from(_scores)));
        _subjectController.clear();
        _scores.clear();
      });
    }
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final student = Student(
        id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _name,
        subjects: _subjects,
      );

      if (widget.student != null) {
        // Update existing student
        StudentService.updateStudent(student.id, student);
      } else {
        // Add new student
        StudentService.addStudent(student);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student != null ? 'Edit Student' : 'Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 20),
              Text('Subjects',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject Name'),
              ),
              TextFormField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Score'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _addScore,
                    child: Text('Add Score'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addSubject,
                    child: Text('Add Subject'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Added Subjects:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              for (var subject in _subjects)
                ListTile(
                  title: Text(subject.name),
                  subtitle: Text('Scores: ${subject.scores.join(', ')}'),
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveStudent,
                  child: Text(widget.student != null
                      ? 'Update Student'
                      : 'Add Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
