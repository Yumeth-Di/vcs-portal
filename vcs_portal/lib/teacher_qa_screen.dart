import 'package:flutter/material.dart';
import 'package:vcs_portal/answer_question_screen.dart';
import 'package:vcs_portal/api_service.dart';
import 'package:intl/intl.dart';

class TeacherQAScreen extends StatefulWidget {
  final int teacherId;
  TeacherQAScreen({required this.teacherId});

  @override
  _TeacherQAScreenState createState() => _TeacherQAScreenState();
}

class _TeacherQAScreenState extends State<TeacherQAScreen> {
  final ApiService _apiService = ApiService('http://192.168.1.6:5000');
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);

    final teacherQuestions =
        await _apiService.getTeacherQuestions(widget.teacherId);

    setState(() {
      _questions = teacherQuestions;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAnswer(Map<String, dynamic> question) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnswerQuestionScreen(
          question: question,
          teacherId: widget.teacherId,
        ),
      ),
    );
    // Refresh after answering
    await _loadQuestions();
  }

  String _formatDate(dynamic date) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.parse(date.toString()));
    } catch (_) {
      return "Unknown date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(225, 0, 73, 137),
          title: Text('Teacher Q&A'),
          centerTitle: true,
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
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _questions.isEmpty
                  ? Center(child: Text('No questions found'))
                  : RefreshIndicator(
                      onRefresh: _loadQuestions,
                      child: ListView.builder(
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final question = _questions[index];
                          final studentName =
                              question['student_name'] ?? "Unknown Student";
                          final status = question['status'] ?? "unknown";
                          final content = question['content'] ?? "(No content)";
                          final createdAt = question['created_at'] ?? "";

                          return Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.85),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'From: $studentName',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Status: $status',
                                        style: TextStyle(
                                          color:
                                              status.toLowerCase() == 'answered'
                                                  ? Colors.green
                                                  : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(content),
                                  SizedBox(height: 8),
                                  Text(
                                    'Asked: ${_formatDate(createdAt)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (status.toLowerCase() != 'answered') ...[
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _navigateToAnswer(question),
                                      child: Text('Answer Question'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ));
  }
}
