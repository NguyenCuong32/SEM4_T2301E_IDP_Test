import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import 'student_detail_screen.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    students = await StudentService().loadStudents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student List"), backgroundColor: Colors.orange),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: ListTile(
              title: Text(
                students[index].name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text("ID: ${students[index].id}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailScreen(student: students[index]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentScreen(student: students[index]),
                    ),
                  ).then((updatedStudent) {
                    if (updatedStudent != null) {
                      setState(() {
                        students[index] = updatedStudent;
                      });
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentScreen(),
            ),
          ).then((newStudent) {
            if (newStudent != null) {
              setState(() {
                students.add(newStudent);
              });
            }
          });
        },
      ),
    );
  }
}
