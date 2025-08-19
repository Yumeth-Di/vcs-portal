import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'get_started_page.dart';
import 'student_home_page.dart';
import 'teacher_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Widget> _getInitialPage() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? role = prefs.getString('role');
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    int? studentId = prefs.getInt('studentId');

    if (isLoggedIn &&
        role != null &&
        username != null &&
        password != null &&
        studentId != null) {
      if (role == "student") {
        return StudentHomePage(
          username: username,
          password: password,
          role: role,
          userId: studentId,
        );
      } else if (role == "teacher") {
        return TeacherHomePage(
          username: username,
          password: password,
          role: role,
        );
      }
    }
    return GetStartedPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Error loading app")),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
