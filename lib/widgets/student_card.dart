import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final Function onEdit;
  final Function onDelete;

  StudentCard({required this.student, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(student.name),
        subtitle: Text("ID: ${student.id}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(),
            ),
          ],
        ),
      ),
    );
  }
}
