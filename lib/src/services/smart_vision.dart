import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/vision_exception.dart';
import '../models/vision_provider.dart';
import '../models/vision_result.dart';

class SmartVision {
  static const String _geminiModel = 'gemini-3.1-flash-lite';

  static Future<VisionResult> analyzeImage({
    required File imageFile,
    required String apiKey,
    required VisionProvider provider,
    String prompt = 'Describe this image briefly.',
  }) async {
    if (apiKey.trim().isEmpty) {
      throw VisionException('API key cannot be empty.');
    }

    if (!await imageFile.exists()) {
      throw VisionException('Image file does not exist.');
    }

    final bytes = await imageFile.readAsBytes();

    if (bytes.isEmpty) {
      throw VisionException('Image file is empty.');
    }

    final base64Image = base64Encode(bytes);

    switch (provider) {
      case VisionProvider.gemini:
        return _analyzeWithGemini(
          apiKey: apiKey,
          prompt: prompt,
          base64Image: base64Image,
        );

      case VisionProvider.openAI:
        throw VisionException('OpenAI support coming soon.');

      case VisionProvider.claude:
        throw VisionException('Claude support coming soon.');

      case VisionProvider.huggingFace:
        throw VisionException('HuggingFace support coming soon.');
    }
  }

  static Future<VisionResult> _analyzeWithGemini({
    required String apiKey,
    required String prompt,
    required String base64Image,
  }) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_geminiModel:generateContent?key=$apiKey',
    );

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                    {
                      'inline_data': {
                        'mime_type': 'image/jpeg',
                        'data': base64Image,
                      },
                    },
                  ],
                },
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 400) {
        throw VisionException(
          'Bad request. Check image format or request body.',
        );
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw VisionException('Invalid or unauthorized API key.');
      }

      if (response.statusCode == 429) {
        throw VisionException('Quota exceeded or too many requests.');
      }

      if (response.statusCode != 200) {
        throw VisionException(
          'Gemini request failed with status ${response.statusCode}: ${response.body}',
        );
      }

      final data = jsonDecode(response.body);

      final mappedJson = {
        'description': data['candidates'][0]['content']['parts'][0]['text'],
      };

      return VisionResult.fromJson(mappedJson);
    } on SocketException {
      throw VisionException('No internet connection.');
    } on TimeoutException {
      throw VisionException('Request timed out. Please try again.');
    } on FormatException {
      throw VisionException('Invalid response format from Gemini.');
    }
  }
}
