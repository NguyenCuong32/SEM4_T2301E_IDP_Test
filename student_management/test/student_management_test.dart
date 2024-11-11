import 'dart:convert';
import 'dart:io';

class Student {
  String id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  // Convert Student to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subjects': subjects.map((subject) => subject.toJson()).toList(),
  };

  // Create Student from JSON
  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'],
    name: json['name'],
    subjects: (json['subjects'] as List)
        .map((subject) => Subject.fromJson(subject))
        .toList(),
  );

  @override
  String toString() {
    return 'ID: $id, Name: $name, Subjects: $subjects';
  }
}

class Subject {
  String name;
  List<double> scores;

  Subject({required this.name, required this.scores});

  Map<String, dynamic> toJson() => {
    'name': name,
    'scores': scores,
  };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    name: json['name'],
    scores: List<double>.from(json['scores']),
  );

  @override
  String toString() {
    return '$name: ${scores.join(", ")}';
  }
}

// Load students from JSON file
Future<List<Student>> loadStudents() async {
  final file = File('Student.json');
  if (!(await file.exists())) {
    await file.writeAsString('[]'); // Initialize empty list if file doesn't exist
  }
  final content = await file.readAsString();
  final jsonData = jsonDecode(content) as List;
  return jsonData.map((json) => Student.fromJson(json)).toList();
}

// Save students to JSON file
Future<void> saveStudents(List<Student> students) async {
  final file = File('Student.json');
  final jsonContent = jsonEncode(students.map((student) => student.toJson()).toList());
  await file.writeAsString(jsonContent);
}

// Display all students
void displayStudents(List<Student> students) {
  for (var student in students) {
    print(student);
  }
}

// Add new student
Future<void> addStudent(List<Student> students, Student student) async {
  students.add(student);
  await saveStudents(students);
}

// Edit student information
Future<void> editStudent(List<Student> students, String id, String newName) async {
  final student = students.firstWhere((student) => student.id == id, orElse: () => throw Exception('Student not found'));
  student.name = newName;
  await saveStudents(students);
}

// Search students by ID or Name
void searchStudent(List<Student> students, String query) {
  final results = students.where((student) => student.id == query || student.name.contains(query));
  for (var student in results) {
    print(student);
  }
}

// Main program
void main() async {
  List<Student> students = await loadStudents();

  // Display all students
  print('Displaying all students:');
  displayStudents(students);

  // Add new student
  var newStudent = Student(id: '003', name: 'Le Van C', subjects: [
    Subject(name: 'Science', scores: [8.0, 9.5]),
    Subject(name: 'Math', scores: [7.0, 6.5])
  ]);
  await addStudent(students, newStudent);
  print('\nAdded new student.');

  // Edit student information
  await editStudent(students, '001', 'Nguyen Van A Updated');
  print('\nEdited student information.');

  // Search for a student by ID or name
  print('\nSearching for student by ID "002":');
  searchStudent(students, '002');

  print('\nSearching for student by name containing "Le":');
  searchStudent(students, 'Le');
}
