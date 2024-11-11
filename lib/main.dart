import 'package:demo3/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'studentProvider.dart';
import 'student_List.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentProvider()..loadStudents(),
      child: MaterialApp(
        title: 'Quản Lý Sinh Viên',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StudentListScreen(),
      ),
    );
  }
}
