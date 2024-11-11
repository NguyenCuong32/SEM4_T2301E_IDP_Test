import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  StudentDetailsScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${student.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Subjects:', style: TextStyle(fontSize: 18)),
            for (var subject in student.subjects)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${subject.name} - Scores: ${subject.scores.join(', ')}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
