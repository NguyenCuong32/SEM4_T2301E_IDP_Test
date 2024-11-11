import 'package:flutter/material.dart';
import 'create_student.dart';
import '../services/student_service.dart';
import '../models/student.dart';
import 'student_details.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadStudents();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void loadStudents() async {
    await StudentService.loadStudents();
    setState(() {
      students = StudentService.getStudents();
    });
  }

  void _onSearchChanged() {
    setState(() {
      final query = searchController.text.toLowerCase();
      students = StudentService.getStudents().where((student) {
        return student.name.toLowerCase().contains(query) ||
            student.id.toString().contains(query);
      }).toList();
    });
  }

  void _navigateToAddStudentScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStudentScreen(
          onStudentAdded: loadStudents,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddStudentScreen,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or ID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
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
                            StudentDetailsScreen(student: student),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddStudentScreen,
        child: Icon(Icons.add),
        tooltip: 'Add Student',
      ),
    );
  }
}
