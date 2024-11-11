import 'package:flutter/material.dart';
import 'package:studentmanagement/models/student.dart';
import 'package:studentmanagement/models/subject.dart';
import 'package:studentmanagement/utils/json_helper.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _students = JsonHelper.loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student List')),
      body: FutureBuilder<List<Student>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return ListTile(
                title: Text(student.name),
                subtitle: Text('ID: ${student.id}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(student.name),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${student.id}'),
                            ...student.subjects.map((subject) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Subject: ${subject.name}'),
                                  Text('Scores: ${subject.scores.join(", ")}'),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController scoreController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Student'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Student Name'),
                ),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(labelText: 'Subject Name'),
                ),
                TextField(
                  controller: scoreController,
                  decoration: InputDecoration(labelText: 'Scores (comma separated)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    subjectController.text.isNotEmpty &&
                    scoreController.text.isNotEmpty) {
                  _addNewStudent(nameController.text,
                      subjectController.text, scoreController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Hàm để thêm sinh viên mới vào danh sách (cập nhật JSON giả lập)
  void _addNewStudent(String name, String subjectName, String scoreText) {

    setState(() {
      _students.then((studentsList) {
        final newId = studentsList.isNotEmpty
            ? studentsList.last.id + 1
            : 1; // Tạo ID mới cho sinh viên
        List<int> scores = scoreText
            .split(',')
            .map((score) => int.tryParse(score.trim()) ?? 0)
            .toList();

        final newSubject = Subject(name: subjectName, scores: scores);
        final newStudent = Student(
          id: newId,
          name: name,
          subjects: [newSubject], // Thêm một môn học mới cho sinh viên
        );

        studentsList.add(newStudent); // Thêm sinh viên vào danh sách
      });
    });
  }
}