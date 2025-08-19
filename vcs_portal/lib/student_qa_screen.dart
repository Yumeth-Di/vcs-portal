import 'package:flutter/material.dart';
import 'package:vcs_portal/api_service.dart';
import 'package:intl/intl.dart';

class StudentQAScreen extends StatefulWidget {
  final int studentId;
  StudentQAScreen({required this.studentId});

  @override
  _StudentQAScreenState createState() => _StudentQAScreenState();
}

class _StudentQAScreenState extends State<StudentQAScreen> {
  final ApiService _apiService = ApiService('http://192.168.1.9:5000');
  final _questionController = TextEditingController();
  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _teachers = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String _message = '';
  int? _selectedTeacherId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final teachers = await _apiService.getTeachers();
      final questions = await _apiService.getStudentQuestions(widget.studentId);

      setState(() {
        _teachers = teachers;
        _questions = questions;
        if (_teachers.isNotEmpty && _selectedTeacherId == null) {
          _selectedTeacherId = _teachers[0]['user_id'] ?? _teachers[0]['id'];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isEmpty || _selectedTeacherId == null) {
      setState(() => _message = 'Please select a teacher and enter a question');
      return;
    }

    setState(() {
      _message = '';
      _isSubmitting = true;
    });

    final result = await _apiService.submitQuestion(
      widget.studentId,
      _questionController.text,
      _selectedTeacherId!,
    );

    setState(() => _isSubmitting = false);

    if (result['status'] == 'success') {
      setState(() {
        _message = 'Question submitted successfully!';
        _questionController.clear();
      });
      await _refreshQuestions();
    } else {
      setState(() {
        _message = result['message'] ?? 'Failed to submit question';
      });
    }
  }

  Future<void> _refreshQuestions() async {
    final questions = await _apiService.getStudentQuestions(widget.studentId);
    setState(() => _questions = questions);
  }

  String _safeGet(Map<String, dynamic>? map, List<String> keys,
      {String fallback = ''}) {
    if (map == null) return fallback;
    for (final key in keys) {
      if (map[key] != null) return map[key].toString();
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 0, 6, 73),
        title: Text(
          'Student Q&A',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshQuestions),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/vc_drone_view.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.50),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            // Top Card
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(0.85),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: _selectedTeacherId,
                        decoration: InputDecoration(
                          labelText: 'Select Teacher',
                          border: OutlineInputBorder(),
                        ),
                        items: _teachers.map((teacher) {
                          return DropdownMenuItem<int>(
                            value: teacher['user_id'] ?? teacher['id'],
                            child: Text(
                                _safeGet(teacher, ['teacher_name', 'name'])),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedTeacherId = value),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          labelText: 'Ask a Question',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 16),
                      _isSubmitting
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submitQuestion,
                              child: Text('Submit Question'),
                            ),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            _message,
                            style: TextStyle(
                              color: _message.contains('success')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // List of Questions
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _questions.isEmpty
                        ? Center(child: Text('No questions found'))
                        : RefreshIndicator(
                            onRefresh: _refreshQuestions,
                            child: ListView.builder(
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                                final question = _questions[index];
                                return Card(
                                  margin: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Question:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text(_safeGet(question,
                                            ['content', 'question_text'])),
                                        SizedBox(height: 8),
                                        Text(
                                          'To: ${_safeGet(question, [
                                                'teacher_name'
                                              ])}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Asked: ${_safeGet(question, [
                                                'created_at'
                                              ])}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Divider(),
                                        if (question['answer'] != null) ...[
                                          Text('Answer:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Text(_safeGet(
                                              question['answer'], ['content'])),
                                          SizedBox(height: 8),
                                          Text(
                                            'Answered by: ${_safeGet(question['answer'], [
                                                  'teacher_name'
                                                ])}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            'Answered: ${_safeGet(question['answer'], [
                                                  'created_at'
                                                ])}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ] else
                                          Text(
                                            'Status: ${_safeGet(question, [
                                                  'status'
                                                ], fallback: 'pending')}',
                                            style: TextStyle(
                                                color: (question['status'] ??
                                                            '') ==
                                                        'answered'
                                                    ? Colors.green
                                                    : Colors.orange),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
