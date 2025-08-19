import 'package:flutter/material.dart';
import 'api_service.dart';
import 'Quiz Homepage.dart';

class QuizSelectPage extends StatefulWidget {
  const QuizSelectPage({super.key});

  @override
  State<QuizSelectPage> createState() => _QuizSelectPageState();
}

class _QuizSelectPageState extends State<QuizSelectPage> {
  bool loading = true;
  String? error;
  List<dynamic> quizzes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await Api_Service.getQuizzes();
      setState(() {
        quizzes = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null)
      return Scaffold(body: Center(child: Text("Error: $error")));

    return Scaffold(
      appBar: AppBar(title: const Text("Available Quizzes")),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return ListTile(
            title: Text(quiz['title']),
            subtitle: Text("Created: ${quiz['created_at']}"),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssignmentAnswerPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
