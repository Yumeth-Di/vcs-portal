import 'package:flutter/material.dart';
import 'api_service.dart';

class QuizResultsPage extends StatefulWidget {
  final int quizId;
  const QuizResultsPage({super.key, required this.quizId});

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  bool loading = true;
  String? error;
  List<dynamic> results = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await Api_Service.getResults(widget.quizId);
      setState(() {
        results = list;
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
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: $error')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final r = results[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Text(r['score'].toString())),
              title: Text(r['student_name'] ?? 'Anonymous'),
              subtitle: Text(
                'Score: ${r['score']} / ${r['total_questions']}\nCompleted: ${r['completed_at']}',
              ),
            ),
          );
        },
      ),
    );
  }
}
