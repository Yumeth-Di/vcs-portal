import 'package:flutter/material.dart';
import 'package:vcs_portal/api_service.dart';

class AnswerQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> question;
  final int teacherId;

  AnswerQuestionScreen({required this.question, required this.teacherId});

  @override
  _AnswerQuestionScreenState createState() => _AnswerQuestionScreenState();
}

class _AnswerQuestionScreenState extends State<AnswerQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  final ApiService _apiService = ApiService('http://192.168.1.6:5000');
  bool _isLoading = false;
  String _message = '';

  Future<void> _submitAnswer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final result = await _apiService.submitAnswer(
      widget.question['id'] ?? widget.question['question_id'],
      widget.teacherId,
      _answerController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      setState(() => _message = 'Answer submitted successfully!');
      await Future.delayed(Duration(milliseconds: 800));
      Navigator.of(context).pop(true); // Pass true to indicate refresh needed
    } else {
      setState(() {
        _message = result['message'] ?? 'Failed to submit answer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.question['student_name'] ?? "Unknown Student";
    final questionText = widget.question['content'] ?? "(No question text)";

    return Scaffold(
        appBar: AppBar(title: Text('Answer Question')),
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
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.85),
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question from ${widget.question['student_name'] ?? "Unknown"}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(widget.question['content'] ?? "(No content)"),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _answerController,
                        decoration: InputDecoration(
                          labelText: 'Your Answer',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter your answer'
                                : null,
                      ),
                      SizedBox(height: 24),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _submitAnswer,
                              child: Text('Submit Answer'),
                            ),
                      SizedBox(height: 16),
                      if (_message.isNotEmpty)
                        Text(
                          _message,
                          style: TextStyle(
                            color: _message.contains('success')
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
