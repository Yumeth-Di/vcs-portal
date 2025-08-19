import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';

class Api_Service {
  static const baseUrl = 'http://192.168.1.6:5000';

  static Future<void> createAnnouncement({
    required String title,
    required String message,
    required String className,
    required int teacherId,
  }) async {
    final r = await http.post(
      Uri.parse("$baseUrl/announcements"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "message": message,
        "class_name": className,
        "teacher_id": teacherId,
      }),
    );
    if (r.statusCode != 201) {
      throw Exception("Failed to create: ${r.body}");
    }
  }

  //--Get all students for teacher page

  static Future<List<dynamic>> students() async {
    final response = await http.get(Uri.parse("$baseUrl/student"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load students");
    }
  }

  //--Get Teachers--

  static Future<List<Map<String, dynamic>>> getTeachers() async {
    final r = await http.get(Uri.parse("$baseUrl/teachers"));
    if (r.statusCode != 200) throw Exception("Failed to load teachers");
    return List<Map<String, dynamic>>.from(jsonDecode(r.body));
  }

  //--Get Classes--

  static Future<List<String>> getClass() async {
    final r = await http.get(Uri.parse("$baseUrl/class"));
    if (r.statusCode != 200) throw Exception("Failed to load classes");
    final arr = jsonDecode(r.body) as List;
    return arr.map((e) => e.toString()).toList();
  }

  // --- Student fetch announcements (with NEW flag) ---
  static Future<List<Announcement>> getStudentAnnouncements(
      int studentId) async {
    final r =
        await http.get(Uri.parse("$baseUrl/announcements/student/$studentId"));
    if (r.statusCode != 200) throw Exception("Failed to load: ${r.body}");
    final arr = jsonDecode(r.body) as List;
    return arr.map((e) => Announcement.fromJson(e)).toList();
  }

  // --- Mark as viewed ---

  static Future<void> markViewed(int annId, int studentId) async {
    final r = await http.post(
      Uri.parse("$baseUrl/announcements/$annId/view"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"student_id": studentId}),
    );
    if (r.statusCode != 200)
      throw Exception("Failed to mark viewed: ${r.body}");
  }

  static Future<String> getStudentClass(int studentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/student?id_student=$studentId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['class_name'];
    } else {
      throw Exception('Failed to fetch student class');
    }
  }

  static Future<List<dynamic>> getQuizzes() async {
    final res = await http.get(Uri.parse('$baseUrl/api/quizzes'));
    if (res.statusCode != 200) throw Exception('Failed to fetch quizzes');
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> createQuiz(String title) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/quizzes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    );
    if (res.statusCode != 201) throw Exception('Failed to create quiz');
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getQuestions(int quizId) async {
    final res =
        await http.get(Uri.parse('$baseUrl/api/quizzes/$quizId/questions'));
    if (res.statusCode != 200) throw Exception('Failed to fetch questions');
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> addQuestion(
      int quizId, Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/quizzes/$quizId/questions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode != 201) throw Exception('Failed to add question');
    return jsonDecode(res.body);
  }

  static Future<void> updateQuestion(
      int quizId, int qid, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/quizzes/$quizId/questions/$qid'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode != 200) throw Exception('Failed to update question');
  }

  static Future<void> deleteQuestion(int quizId, int qid) async {
    final res = await http
        .delete(Uri.parse('$baseUrl/api/quizzes/$quizId/questions/$qid'));
    if (res.statusCode != 200) throw Exception('Failed to delete question');
  }

  static Future<void> saveResult(
      int quizId, String studentName, int score, int totalQuestions) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/quizzes/$quizId/results'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_name': studentName,
        'score': score,
        'total_questions': totalQuestions,
      }),
    );
    if (res.statusCode != 201) throw Exception('Failed to save result');
  }

  static Future<List<dynamic>> getResults(int quizId) async {
    final res =
        await http.get(Uri.parse('$baseUrl/api/quizzes/$quizId/results'));
    if (res.statusCode != 200) throw Exception('Failed to fetch results');
    return jsonDecode(res.body);
  }

  //Get student id from user id
  static Future<int?> getStuId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/student/$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id_student'];
    } else {
      return null; // handle error properly in production
    }
  }
}

class ClassLink {
  final String className;
  final String url;
  final String? updatedAt;
  ClassLink({required this.className, required this.url, this.updatedAt});

  factory ClassLink.fromJson(Map<String, dynamic> j) => ClassLink(
      className: (j['class'] as String?) ?? '',
      url: (j['url'] as String?) ?? '',
      updatedAt: j['updated_at'] as String?);
}

class ApiService {
  final String baseUrl = 'http://192.168.1.6:5000';

  ApiService(String trim);
  final _client = http.Client();

  Future<List<String>> fetchClasses() async {
    final res = await _client.get(Uri.parse("$baseUrl/classes"));
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch classes");
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => e.toString()).toList();
  }

  Future<String> getClassByStudentName(String name) async {
    final uri =
        Uri.parse("$baseUrl/get_class?name=${Uri.encodeComponent(name)}");
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Student not found or server error: ${res.body}");
    }
    final data = jsonDecode(res.body);
    return data['class'] as String;
  }

  Future<ClassLink> getLinkForClass(String className) async {
    final uri =
        Uri.parse("$baseUrl/link?class=${Uri.encodeComponent(className)}");
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Failed to get link");
    }
    return ClassLink.fromJson(jsonDecode(res.body));
  }

  Future<void> saveLinkForClass(String className, String url) async {
    final res = await _client.post(
      Uri.parse("$baseUrl/link"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"class": className, "url": url}),
    );
    if (res.statusCode != 201) {
      throw Exception("Failed to save: ${res.body}");
    }
  }

  // Get student ID by username
  Future<int?> getStudentId(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/student/id?username=$username'),
      );
      print('getStudentId Response status: ${response.statusCode}');
      print('getStudentId Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['student_id'];
      } else {
        final errorData = jsonDecode(response.body);
        print('getStudentId Error: ${errorData['message']}');
        return null;
      }
    } catch (e) {
      print('Exception in getStudentId: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTeachers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/teachers'));
      print('getTeachers Response status: ${response.statusCode}');
      print('getTeachers Response body: ${response.body}');

      if (response.statusCode == 200) {
        final teachers =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Parsed ${teachers.length} teachers');
        return teachers;
      }
      return [];
    } catch (e) {
      print('Exception in getTeachers: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTeacherQuestions(int teacherId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/questions/teacher/$teacherId'));
      print('getTeacherQuestions Response status: ${response.statusCode}');
      print('getTeacherQuestions Response body: ${response.body}');

      if (response.statusCode == 200) {
        final questions =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Parsed ${questions.length} questions for teacher $teacherId');

        // Print each question and its answer status
        for (var q in questions) {
          print('Question ID: ${q['id']}, Content: ${q['content']}');
          print('Has answer: ${q['answer'] != null}');
          if (q['answer'] != null) {
            print('Answer content: ${q['answer']['content']}');
          }
        }

        return questions;
      }
      return [];
    } catch (e) {
      print('Error in getTeacherQuestions: $e');
      return [];
    }
  }

  // Get teacher ID by username
  Future<int?> getTeacherId(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/teacher/id?username=$username'),
      );
      print('getTeacherId Response status: ${response.statusCode}');
      print('getTeacherId Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['teacher_id'];
      } else {
        final errorData = jsonDecode(response.body);
        print('getTeacherId Error: ${errorData['message']}');
        return null;
      }
    } catch (e) {
      print('Exception in getTeacherId: $e');
      return null;
    }
  }

  // Submit a question
  Future<Map<String, dynamic>> submitQuestion(
      int studentId, String content, int teacherId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/questions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_id': studentId,
          'content': content,
          'teacher_id': teacherId,
        }),
      );
      print('submitQuestion Response status: ${response.statusCode}');
      print('submitQuestion Response body: ${response.body}');

      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('submitQuestion JSON decode error: $e');
        return {'status': 'error', 'message': 'Invalid response from server'};
      }
    } catch (e) {
      print('Exception in submitQuestion: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Get all questions (for teachers)
  Future<List<Map<String, dynamic>>> getAllQuestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/questions'));
      print('getAllQuestions Response status: ${response.statusCode}');
      print('getAllQuestions Response body: ${response.body}');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      print('Error in getAllQuestions: $e');
      return [];
    }
  }

  // Submit an answer
  Future<Map<String, dynamic>> submitAnswer(
      int questionId, int teacherId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/answers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question_id': questionId,
          'teacher_id': teacherId,
          'content': content,
        }),
      );
      print('submitAnswer Response status: ${response.statusCode}');
      print('submitAnswer Response body: ${response.body}');

      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('submitAnswer JSON decode error: $e');
        return {'status': 'error', 'message': 'Invalid response from server'};
      }
    } catch (e) {
      print('Exception in submitAnswer: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Get questions for a specific student
  Future<List<Map<String, dynamic>>> getStudentQuestions(int studentId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/questions/$studentId'));
      print('getStudentQuestions Response status: ${response.statusCode}');
      print('getStudentQuestions Response body: ${response.body}');

      if (response.statusCode == 200) {
        final questions =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Parsed ${questions.length} questions');

        // Print each question and its answer status
        for (var q in questions) {
          print('Question ID: ${q['id']}, Content: ${q['content']}');
          print('Has answer: ${q['answer'] != null}');
          if (q['answer'] != null) {
            print('Answer content: ${q['answer']['content']}');
          }
        }

        return questions;
      }
      return [];
    } catch (e) {
      print('Error in getStudentQuestions: $e');
      return [];
    }
  }
}
