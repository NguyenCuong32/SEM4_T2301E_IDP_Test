import 'student_manager.dart';

void main() async {
  final manager = StudentManager();
  await manager.loadFromFile();
  await manager.showMenu();
}
