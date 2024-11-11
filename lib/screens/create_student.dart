// screens/add_student_screen.dart
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class AddStudentScreen extends StatefulWidget {
  final Function onStudentAdded;

  AddStudentScreen({required this.onStudentAdded});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  void _addStudent() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final int id = int.parse(_idController.text);

      // Create a new student object
      final newStudent = Student(id: id, name: name, subjects: []);

      // Add the student through the StudentService
      StudentService.addStudent(newStudent);

      // Notify the parent to refresh the student list
      widget.onStudentAdded();

      // Return to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'Student ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addStudent,
                child: Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
