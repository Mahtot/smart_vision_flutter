import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/vision_exception.dart';
import '../models/vision_result.dart';
import 'vision_service_interface.dart';

class GeminiVisionService implements VisionServiceInterface {
  static const String _model = 'gemini-2.0-flash';
  static const Duration _timeout = Duration(seconds: 30);

  @override
  Future<VisionResult> analyzeImage({
    required String apiKey,
    required String prompt,
    required String base64Image,
    String mimeType = 'image/jpeg',
  }) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$apiKey',
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
                        'mime_type': mimeType,
                        'data': base64Image,
                      },
                    },
                  ],
                },
              ],
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 400) {
        throw VisionException(
          'Bad request. Check the image format or request body.',
        );
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw VisionException('Invalid or unauthorized Gemini API key.');
      }

      if (response.statusCode == 429) {
        throw VisionException(
          'Gemini free tier limit reached. Please wait a moment and try again.',
        );
      }

      if (response.statusCode != 200) {
        throw VisionException(
          'Gemini request failed with status ${response.statusCode}: ${response.body}',
        );
      }

      final data = jsonDecode(response.body);

      final candidates = data['candidates'];

      if (candidates == null || candidates.isEmpty) {
        throw VisionException('Gemini returned no candidates.');
      }

      final parts = candidates[0]?['content']?['parts'];

      if (parts == null || parts.isEmpty) {
        throw VisionException('Gemini returned no content parts.');
      }

      final text = parts[0]?['text'];

      if (text == null || text.toString().trim().isEmpty) {
        throw VisionException('Gemini returned an empty response.');
      }

      return VisionResult(description: text.toString().trim());
    } on SocketException {
      throw VisionException('No internet connection.');
    } on TimeoutException {
      throw VisionException('Gemini request timed out. Please try again.');
    } on FormatException {
      throw VisionException('Invalid response format from Gemini.');
    }
  }
}
