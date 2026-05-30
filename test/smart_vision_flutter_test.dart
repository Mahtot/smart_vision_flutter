import 'package:flutter_test/flutter_test.dart';
import 'package:smart_vision_flutter/smart_vision_flutter.dart';

void main() {
  test('VisionConfig stores config values correctly', () {
    const config = VisionConfig(
      apiKey: 'test-key',
      provider: VisionProvider.gemini,
      prompt: 'Describe image',
    );

    expect(config.apiKey, 'test-key');
    expect(config.provider, VisionProvider.gemini);
    expect(config.prompt, 'Describe image');
  });
}
