import 'package:flutter/material.dart';
import '../models/students.dart';
import '../services/student_service.dart';
import 'student_add_screen.dart';
import 'student_edit_screen.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _studentService = StudentService();
  List<Student> students = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    students = await _studentService.getAllStudents();
    setState(() {});
  }

  void _searchStudent(String query) async {
    final result = await _studentService.searchStudent(query);
    setState(() {
      students = result != null ? [result] : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentAddScreen()),
              ).then((_) => _loadStudents()); // Reload the students after adding
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Name or ID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _searchStudent,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('ID: ${student.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StudentEditScreen(student: student)),
                    ).then((_) => _loadStudents());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
