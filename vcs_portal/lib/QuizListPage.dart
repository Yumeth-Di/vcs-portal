import 'package:flutter/material.dart';
import 'api_service.dart';
import 'Quiz Teachers Homepage.dart';

class QuizListPage extends StatefulWidget {
  const QuizListPage({super.key});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
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

  Future<void> _createQuiz() async {
    final titleController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create New Quiz"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Quiz Title"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Create")),
        ],
      ),
    );
    if (ok == true) {
      final quiz = await Api_Service.createQuiz(titleController.text);
      setState(() => quizzes.insert(0, quiz));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null)
      return Scaffold(body: Center(child: Text("Error: $error")));

    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Quizzes")),
      floatingActionButton: FloatingActionButton(
        onPressed: _createQuiz,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return ListTile(
            title: Text(quiz['title']),
            subtitle: Text("Created: ${quiz['created_at']}"),
            trailing: const Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizTeachersHomepage(quizId: quiz['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
