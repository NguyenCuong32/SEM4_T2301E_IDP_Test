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
  List<Student> filteredStudents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    students = await StudentService().loadStudents();
    filteredStudents = students; // Initially, display all students
    setState(() {});
  }

  void filterStudents(String query) {
    List<Student> results = [];
    if (query.isEmpty) {
      results = students; // Show all students if the query is empty
    } else {
      results = students.where((student) {
        final nameLower = student.name.toLowerCase();
        final idLower = student.id.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) || idLower.contains(searchLower);
      }).toList();
    }
    setState(() {
      filteredStudents = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student List")),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by Name or ID",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (query) => filterStudents(query),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        filteredStudents[index].name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("ID: ${filteredStudents[index].id}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetailScreen(student: filteredStudents[index]),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditStudentScreen(student: filteredStudents[index]),
                            ),
                          ).then((updatedStudent) {
                            if (updatedStudent != null) {
                              setState(() {
                                int originalIndex = students.indexWhere(
                                        (student) => student.id == updatedStudent.id);
                                students[originalIndex] = updatedStudent;
                                filterStudents(searchController.text); // Update filtered list
                              });
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
                filterStudents(searchController.text); // Update filtered list
              });
            }
          });
        },
      ),
    );
  }
}
