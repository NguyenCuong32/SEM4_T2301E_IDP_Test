import 'package:demo3/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studentProvider.dart';

class StudentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
          if (studentProvider.students.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: studentProvider.students.length,
            itemBuilder: (context, index) {
              final student = studentProvider.students[index];
              return ListTile(
                title: Text(student.name),
                subtitle: Text('ID: ${student.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newStudent = Student(id: '3', name: 'Charlie', subjects: []);
          Provider.of<StudentProvider>(context, listen: false).addStudent(newStudent);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

