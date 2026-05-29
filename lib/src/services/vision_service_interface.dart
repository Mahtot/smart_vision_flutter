import '../models/vision_result.dart';

abstract class VisionServiceInterface {
  Future<VisionResult> analyzeImage({
    required String apiKey,
    required String prompt,
    required String base64Image,
    String mimeType = 'image/jpeg',
  });
}
