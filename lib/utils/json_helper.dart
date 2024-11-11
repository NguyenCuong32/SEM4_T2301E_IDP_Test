import 'dart:convert';

import 'package:studentmanagement/models/student.dart';


class JsonHelper {
  static String _studentsJson = '''
  [
    {
      "id": 1,
      "name": "Truong Gia Binh",
      "subjects": [
        {
          "name": "Math",
          "scores": [10, 9, 8]
        },
        {
          "name": "Physics",
          "scores": [7, 8, 9]
        }
      ]
    },
    {
      "id": 2,
      "name": "Le Truong Tung",
      "subjects": [
        {
          "name": "Chemistry",
          "scores": [8, 9, 10]
        },
        {
          "name": "Biology",
          "scores": [7, 7, 8]
        }
      ]
    }
  ]
  ''';


  static Future<List<Student>> loadStudents() async {
    try {

      final List<dynamic> studentsJson = json.decode(_studentsJson);


      return studentsJson.map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      print("Error parsing JSON: $e");
      return [];
    }
  }


  static Future<void> saveStudents(List<Student> students) async {

  }
}