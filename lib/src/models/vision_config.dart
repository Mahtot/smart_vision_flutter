import 'vision_provider.dart';

class VisionConfig {
  final String apiKey;
  final VisionProvider provider;
  final String prompt;

  const VisionConfig({
    required this.apiKey,
    required this.provider,
    this.prompt = 'Describe this image briefly.',
  });
}
