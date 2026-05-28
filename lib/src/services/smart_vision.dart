import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/vision_result.dart';

class SmartVision {
  static const String _model = 'gemini-3.1-flash-lite';

  static Future<VisionResult> analyzeImage({
    required File imageFile,
    required String apiKey,
    String prompt = 'Describe this image briefly.',
  }) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final mappedJson = {
      'description': data['candidates'][0]['content']['parts'][0]['text'],
    };

    return VisionResult.fromJson(mappedJson);
  }
}
