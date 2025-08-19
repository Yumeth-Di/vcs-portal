import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'chat_service.dart';

void main() {
  const apiKey = "AIzaSyB1X5nOAzgQTzYIZc4c-JkwO_Li65fgpIY";
  final geminiService = GeminiService(apiKey);

  runApp(ChatApp(geminiService: geminiService));
}

class ChatApp extends StatelessWidget {
  final GeminiService geminiService;

  const ChatApp({super.key, required this.geminiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VCS Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatPage(geminiService: geminiService),
    );
  }
}
