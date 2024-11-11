import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  StudentDetailScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: ${student.id}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Name: ${student.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Text(
              "Subjects and Scores",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 8.0),
                itemCount: student.subjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        student.subjects[index].name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        student.subjects[index].score.toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
