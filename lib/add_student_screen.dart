import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'student_provider.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<Map<String, dynamic>> _subjects = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            ElevatedButton(
              onPressed: _addSubjectDialog,
              child: Text("Add Subject"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return ListTile(
                    title: Text(subject['name']),
                    subtitle: Text('Scores: ${subject['scores'].join(', ')}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _subjects.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final id = int.tryParse(_idController.text);
                final name = _nameController.text;

                if (id != null && name.isNotEmpty) {
                  provider.addStudent(id, name, _subjects);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter a valid ID and name")),
                  );
                }
              },
              child: Text("Save Student"),
            ),
          ],
        ),
      ),
    );
  }

  void _addSubjectDialog() {
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController scoresController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Subject"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: InputDecoration(labelText: 'Subject Name'),
              ),
              TextField(
                controller: scoresController,
                decoration: InputDecoration(labelText: 'Scores (tach dau)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final scores = scoresController.text
                    .split(',')
                    .map((e) => int.tryParse(e.trim()) ?? 0)
                    .toList();
                setState(() {
                  _subjects.add({
                    'name': subjectController.text,
                    'scores': scores,
                  });
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
