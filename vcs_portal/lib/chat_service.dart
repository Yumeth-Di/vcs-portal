import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash', // ✅ updated model
          apiKey: apiKey,
        );

  Future<String> sendMessage(String message) async {
    try {
      final response = await _model.generateContent([Content.text(message)]);
      if (response.text == null || response.text!.isEmpty) {
        return "⚠️ No response from Gemini";
      }
      return response.text!;
    } catch (e) {
      return "❌ Error: $e";
    }
  }
}
