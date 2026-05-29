import 'package:smart_vision_flutter/smart_vision_flutter.dart';
import 'package:smart_vision_flutter/src/services/vision_service_interface.dart';

class OpenaiVisionService implements VisionServiceInterface {
  @override
  Future<VisionResult> analyzeImage({
    required String apiKey,
    required String prompt,
    required String base64Image,
    String mimeType = 'image/jpeg',
  }) async {
    throw VisionException(
      'OpenAI support coming soon. Follow updates at pub.dev/packages/smart_vision_flutter',
    );
  }
}
