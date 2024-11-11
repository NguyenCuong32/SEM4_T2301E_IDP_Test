import 'dart:convert';
import 'package:demo_test/student.dart';
import 'package:demo_test/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Student List'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Student>> students;
  List<Student> allStudents = [];
  TextEditingController searchController = TextEditingController();
  int nextId = 1;
  @override
  void initState() {
    super.initState();
    students = loadStudents();
  }

  Future<List<Student>> loadStudents() async {
    String jsonString = await rootBundle.loadString('assets/student.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    List<Student> studentsList = (jsonResponse['students'] as List)
        .map((studentJson) => Student.fromJson(studentJson))
        .toList();
    allStudents = studentsList;
    nextId = studentsList.isNotEmpty ? studentsList.last.id + 1 : 1;
    return studentsList;
  }

  void addStudent(Student newStudent) {
    setState(() {
      newStudent.id = nextId++;
      allStudents.add(newStudent);
      students = Future.value(allStudents);
    });
  }
  List<Student> searchStudents(String query) {
    if (query.isEmpty) {
      return allStudents;
    }
    return allStudents.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.id.toString().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Student>>(
        future: students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading students'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students available'));
          } else {
            final studentsList = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search student by name or ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchStudents(searchController.text).length,
                    itemBuilder: (context, index) {
                      final student = searchStudents(searchController.text)[index];
                      return ListTile(
                        title: Text(student.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${student.id}'),
                            for (var subject in student.subjects)
                              Text(
                                '${subject.name}: ${subject.scores.join(', ')}',
                              ),
                          ],
                        ),
                        onTap: () {
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final newStudent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStudentScreen(
                          onAdd: addStudent,
                          nextId: nextId,
                        ),
                      ),
                    );
                    if (newStudent != null) {
                      addStudent(newStudent);
                    }
                  },
                  child: const Text('Add New Student'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class StudentSearchDelegate extends SearchDelegate {
  final List<Student> allStudents;

  StudentSearchDelegate(this.allStudents);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allStudents.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.id.toString().contains(query);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final student = results[index];
        return ListTile(
          title: Text(student.name),
          subtitle: Text('ID: ${student.id}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allStudents.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.id.toString().contains(query);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final student = suggestions[index];
        return ListTile(
          title: Text(student.name),
          subtitle: Text('ID: ${student.id}'),
        );
      },
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  final Function(Student) onAdd;
  final int nextId;

  const AddStudentScreen({super.key, required this.onAdd, required this.nextId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final List<Subject> subjects = [];

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            ElevatedButton(
              onPressed: () {
                subjects.add(Subject(name: 'Math', scores: [10, 9, 8]));
              },
              child: const Text('Add Subject'),
            ),
            ElevatedButton(
              onPressed: () {
                final newStudent = Student(
                  id: nextId,
                  name: nameController.text,
                  subjects: subjects,
                );
                onAdd(newStudent);
                Navigator.pop(context);
              },
              child: const Text('Save Student'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditStudentScreen extends StatelessWidget {
  final Student student;
  final Function(int, String, List<Subject>) onEdit;

  const EditStudentScreen({super.key, required this.student, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: student.name);
    final List<Subject> subjects = List.from(student.subjects);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            ElevatedButton(
              onPressed: () {
                subjects.add(Subject(name: 'New Subject', scores: [10, 9]));
              },
              child: const Text('Edit Subjects'),
            ),
            ElevatedButton(
              onPressed: () {
                onEdit(student.id, nameController.text, subjects);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}


