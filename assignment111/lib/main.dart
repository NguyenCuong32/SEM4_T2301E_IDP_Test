import 'package:assignment111/student.dart';
import 'package:assignment111/studentManager.dart';

void main() {
  var manager = StudentManager();
  manager.loadStudents('Student.json');

  // show all students
  manager.displayStudents();

  // add students
  // with id, name, subjects and points
  var newStudent = Student('3', 'Nguyen Van B', {'English': [8, 9, 7],'Math':[2,3,4]});
  manager.addStudent(newStudent);
  manager.saveStudents('Student.json');

  // Edit
  manager.editStudent('3', newName: 'Nguyen Van C', newSubjects: {'Math': [10, 10, 9],'Physic':[1,2,3]});
  manager.saveStudents('Student.json');

  // FindByName

var student = manager.searchStudent('Nguyen Van B');
if (student != null) {
  print('Found student: Name: ${student.name}, ID: ${student.id}');
  student.subjects.forEach((subject, scores) {
    print('Subject: $subject, Scores: $scores');
  });
} else {
  print('Student not found');
}

}
