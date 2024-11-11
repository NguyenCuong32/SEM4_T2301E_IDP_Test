// student_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'student_provider.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final students = provider.students;

    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStudentScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student['name']),
            subtitle: Text('ID: ${student['id']}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
