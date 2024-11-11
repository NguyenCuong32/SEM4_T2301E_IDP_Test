import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';

void main() {
  runApp(StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: StudentListScreen(),
    );
  }
}
