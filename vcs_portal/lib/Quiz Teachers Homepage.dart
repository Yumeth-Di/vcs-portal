import 'package:flutter/material.dart';
import 'api_service.dart';
import 'QuizResultsPage.dart';

class QuizTeachersHomepage extends StatefulWidget {
  final int quizId;
  const QuizTeachersHomepage({super.key, required this.quizId});

  @override
  State<QuizTeachersHomepage> createState() => _QuizTeachersHomepageState();
}

class _QuizTeachersHomepageState extends State<QuizTeachersHomepage> {
  List<Map<String, dynamic>> questions = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final qs = await Api_Service.getQuestions(widget.quizId);
      setState(() {
        questions = List<Map<String, dynamic>>.from(qs);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  void _add() {
    setState(() {
      questions.add({
        'id': null,
        'question': '',
        'option_a': '',
        'option_b': '',
        'option_c': '',
        'option_d': '',
        'correct_option': 'A',
      });
    });
  }

  Future<void> _save(int i) async {
    final row = questions[i];
    final payload = {
      'question': row['question'] ?? '',
      'option_a': row['option_a'] ?? '',
      'option_b': row['option_b'] ?? '',
      'option_c': row['option_c'] ?? '',
      'option_d': row['option_d'] ?? '',
      'correct_option': row['correct_option'] ?? 'A',
    };
    try {
      if (row['id'] == null) {
        final saved = await Api_Service.addQuestion(widget.quizId, payload);
        setState(() => questions[i]['id'] = saved['id']);
      } else {
        await Api_Service.updateQuestion(
            widget.quizId, row['id'] as int, payload);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _delete(int i) async {
    final row = questions[i];
    try {
      if (row['id'] != null) {
        await Api_Service.deleteQuestion(widget.quizId, row['id'] as int);
      }
      setState(() => questions.removeAt(i));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null)
      return Scaffold(body: Center(child: Text('Error: $error')));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz #${widget.quizId}'),
        actions: [
          IconButton(onPressed: _add, icon: const Icon(Icons.add)),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizResultsPage(quizId: widget.quizId),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final row = questions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question ID: ${row['id'] ?? 'new'}'),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Question'),
                    controller: TextEditingController(text: row['question'])
                      ..selection = TextSelection.collapsed(
                          offset: (row['question'] ?? '').length),
                    onChanged: (v) => row['question'] = v,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Option A'),
                          controller:
                              TextEditingController(text: row['option_a'])
                                ..selection = TextSelection.collapsed(
                                    offset: (row['option_a'] ?? '').length),
                          onChanged: (v) => row['option_a'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Option B'),
                          controller:
                              TextEditingController(text: row['option_b'])
                                ..selection = TextSelection.collapsed(
                                    offset: (row['option_b'] ?? '').length),
                          onChanged: (v) => row['option_b'] = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Option C'),
                          controller:
                              TextEditingController(text: row['option_c'])
                                ..selection = TextSelection.collapsed(
                                    offset: (row['option_c'] ?? '').length),
                          onChanged: (v) => row['option_c'] = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Option D'),
                          controller:
                              TextEditingController(text: row['option_d'])
                                ..selection = TextSelection.collapsed(
                                    offset: (row['option_d'] ?? '').length),
                          onChanged: (v) => row['option_d'] = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: (row['correct_option'] ?? 'A') as String,
                    items: const [
                      DropdownMenuItem(value: 'A', child: Text('Correct: A')),
                      DropdownMenuItem(value: 'B', child: Text('Correct: B')),
                      DropdownMenuItem(value: 'C', child: Text('Correct: C')),
                      DropdownMenuItem(value: 'D', child: Text('Correct: D')),
                    ],
                    onChanged: (v) => setState(() => row['correct_option'] = v),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _save(index),
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _delete(index),
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
