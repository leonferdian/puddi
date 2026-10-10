import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class TranslationRepository {
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    required String apiKey,
  });
}

class GeminiTranslationRepository implements TranslationRepository {
  @override
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    required String apiKey,
  }) async {
    if (apiKey.isEmpty || text.trim().isEmpty) {
      // If the API key is not configured yet, just return the text
      return text; 
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

    final prompt = "Translate the following text from $sourceLanguage to $targetLanguage. Only return the translated text without quotes, conversational fillers, or explanations.\n\n$text";

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.1, // Low temperature for factual translation accuracy
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'].toString().trim();
          }
        }
      } else {
        print("Gemini API Error: ${response.statusCode} - ${response.body}");
        return "[Error] $text";
      }
    } catch (e) {
      print("Gemini API Exception: $e");
      return "[Failed] $text";
    }

    return text;
  }
}
