import 'package:flutter/material.dart';
import '../models/student.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  EditStudentScreen({required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  List<Subject> subjects = [];

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.student.id);
    _nameController = TextEditingController(text: widget.student.name);
    subjects = widget.student.subjects
        .map((subject) => Subject(name: subject.name, score: subject.score))
        .toList();
  }

  void _addSubject() {
    setState(() {
      subjects.add(Subject(name: '', score: 0));
    });
  }

  void _removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  void _saveChanges() {
    widget.student.id = _idController.text;
    widget.student.name = _nameController.text;
    widget.student.subjects = subjects;
    Navigator.pop(context, widget.student);
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Student"), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_idController, "Student ID"),
            SizedBox(height: 10),
            _buildTextField(_nameController, "Student Name"),
            SizedBox(height: 16.0),
            Text("Subjects and Scores", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          labelText: "Subject Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (value) => subjects[index].name = value,
                        controller: TextEditingController(text: subjects[index].name),
                      ),
                      trailing: Container(
                        width: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Score",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (value) => subjects[index].score = int.tryParse(value) ?? 0,
                                controller: TextEditingController(text: subjects[index].score.toString()),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _removeSubject(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addSubject,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("Add Subject", style: TextStyle(color: Colors.orange)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("Save Changes", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
