import 'StudentManager.dart';

void main() async {
  final manager = StudentManager();
  await manager.loadFromFile();
  await manager.showMenu();
}
