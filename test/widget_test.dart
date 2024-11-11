import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management/main.dart';
import 'package:student_management/models/student.dart';
import 'package:student_management/screens/student_list.dart';
import 'package:student_management/screens/student_form.dart';
import 'package:student_management/services/student_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Load mock data if needed or clear existing data
    await StudentService.loadStudents();
    StudentService.clearAll();
    StudentService.addStudent(
        Student(id: 1, name: 'Truong Gia Binh', subjects: [
      Subject(name: 'Math', scores: [10, 9, 8]),
      Subject(name: 'Physics', scores: [7, 8, 9]),
    ]));
  });

  testWidgets('Hiển thị danh sách sinh viên', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: StudentListScreen()));

    expect(find.text('Student Management'), findsOneWidget);
    expect(find.text('Truong Gia Binh'), findsOneWidget);
    expect(find.text('ID: 1'), findsOneWidget);
  });

  testWidgets('Thêm sinh viên mới', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: StudentListScreen()));

    // Nhấn vào nút thêm sinh viên
    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Nhập thông tin sinh viên mới
    await tester.enterText(find.byType(TextFormField).first, 'Le Truong Tung');
    await tester.enterText(find.byType(TextFormField).at(1), 'Chemistry');
    await tester.enterText(find.byType(TextFormField).at(2), '8');

    // Thêm điểm và môn học
    await tester.tap(find.text('Add Score'));
    await tester.pump();
    await tester.tap(find.text('Add Subject'));
    await tester.pump();

    // Lưu sinh viên mới
    await tester.tap(find.text('Add Student'));
    await tester.pumpAndSettle();

    // Kiểm tra xem sinh viên mới đã được thêm chưa
    expect(find.text('Le Truong Tung'), findsOneWidget);
  });

  testWidgets('Sửa thông tin sinh viên', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: StudentListScreen()));

    // Tìm và nhấn vào nút chỉnh sửa
    final editButton = find.byIcon(Icons.edit).first;
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    // Sửa tên sinh viên
    await tester.enterText(find.byType(TextFormField).first, 'Updated Name');
    await tester.tap(find.text('Update Student'));
    await tester.pumpAndSettle();

    // Kiểm tra xem tên sinh viên đã được cập nhật chưa
    expect(find.text('Updated Name'), findsOneWidget);
  });

  testWidgets('Tìm kiếm sinh viên theo Tên hoặc ID',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: StudentListScreen()));

    // Nhập vào thanh tìm kiếm
    await tester.enterText(find.byType(TextField), 'Truong Gia Binh');
    await tester.pump();

    // Kiểm tra xem kết quả tìm kiếm có hiển thị đúng sinh viên không
    expect(find.text('Truong Gia Binh'), findsOneWidget);
  });
}
