import 'dart:convert';
import 'dart:io';
import 'package:smart_vision_flutter/smart_vision_flutter.dart';
import 'package:smart_vision_flutter/src/services/claude_vision_service.dart';
import 'package:smart_vision_flutter/src/services/gemini_vision_service.dart';
import 'package:smart_vision_flutter/src/services/huggingface_vision_service.dart';
import 'package:smart_vision_flutter/src/services/openai_vision_service.dart';
import 'package:smart_vision_flutter/src/services/vision_service_interface.dart';

class SmartVision {
  final VisionConfig config;

  const SmartVision({required this.config});

  static String _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    const map = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
    };
    return map[ext] ?? 'image/jpeg';
  }

  Future<VisionResult> analyzeImage({required File imageFile}) async {
    final apiKey = config.apiKey;
    final provider = config.provider;
    final prompt = config.prompt;
    if (apiKey.trim().isEmpty) {
      throw VisionException('API key cannot be empty.');
    }

    if (prompt.trim().isEmpty) {
      throw VisionException('Prompt cannot be empty.');
    }

    if (!await imageFile.exists()) {
      throw VisionException('Image file does not exist.');
    }

    final bytes = await imageFile.readAsBytes();

    if (bytes.isEmpty) {
      throw VisionException('Image file is empty.');
    }
    if (bytes.length > 4 * 1024 * 1024) {
      throw VisionException(
        'Image is too large. Please use an image under 4MB.',
      );
    }

    final base64Image = base64Encode(bytes);
    final mimeType = _getMimeType(imageFile.path);

    final VisionServiceInterface service = switch (provider) {
      VisionProvider.gemini => GeminiVisionService(),
      VisionProvider.openAi => OpenaiVisionService(),
      VisionProvider.claude => ClaudeVisionService(),
      VisionProvider.huggingFace => HuggingFaceVisionService(),
    };

    return service.analyzeImage(
      apiKey: apiKey,
      prompt: prompt,
      base64Image: base64Image,
      mimeType: mimeType,
    );
  }
}
