# Smart Vision Flutter

A Flutter package that simplifies AI vision integration for Flutter developers.

`smart_vision_flutter` allows developers to send images to AI vision models and receive structured image analysis results with a clean, provider-based architecture.

---

## Features

✅ AI-powered image analysis

✅ Simple and clean API

✅ Structured response model

✅ Built-in validation and error handling

✅ Automatic image MIME type detection

✅ Provider-based architecture

✅ Easy to extend with additional AI providers

---

## Supported Providers

| Provider | Status |
|----------|--------|
| Gemini | ✅ Supported |
| Claude | 🔜 Coming soon |
| OpenAI | 🔜 Coming soon |
| HuggingFace | 🔜 Coming soon |

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  smart_vision_flutter: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## Import

```dart
import 'package:smart_vision_flutter/smart_vision_flutter.dart';
```

---

## Quick Start

### 1. Create a configuration

```dart
final vision = SmartVision(
  config: VisionConfig(
    apiKey: 'YOUR_GEMINI_API_KEY',
    provider: VisionProvider.gemini,
  ),
);
```

### 2. Analyze an image

```dart
final result = await vision.analyzeImage(
  imageFile: imageFile,
);

print(result.description);
```

---

## Complete Example

```dart
import 'dart:io';

import 'package:smart_vision_flutter/smart_vision_flutter.dart';

Future<void> analyzeImage(File imageFile) async {
  final vision = SmartVision(
    config: VisionConfig(
      apiKey: 'YOUR_GEMINI_API_KEY',
      provider: VisionProvider.gemini,
    ),
  );

  try {
    final result = await vision.analyzeImage(
      imageFile: imageFile,
    );

    print(result.description);
  } on VisionException catch (e) {
    print(e.message);
  }
}
```

---

## Using a Custom Prompt

By default, Smart Vision uses:

```text
Describe this image briefly.
```

You can customize the prompt:

```dart
final vision = SmartVision(
  config: VisionConfig(
    apiKey: 'YOUR_GEMINI_API_KEY',
    provider: VisionProvider.gemini,
    prompt: 'Describe this image in detail and identify important objects.',
  ),
);
```

---

## Picking Images with image_picker

Example:

```dart
final ImagePicker picker = ImagePicker();

final XFile? image = await picker.pickImage(
  source: ImageSource.gallery,
);

if (image != null) {
  final file = File(image.path);

  final result = await vision.analyzeImage(
    imageFile: file,
  );

  print(result.description);
}
```

---

## Response Model

Smart Vision returns a `VisionResult`.

```dart
final result = await vision.analyzeImage(
  imageFile: imageFile,
);

print(result.description);
```

### VisionResult

```dart
class VisionResult {
  final String description;
}
```

---

## Error Handling

The package throws `VisionException` for known failures.

Example:

```dart
try {
  final result = await vision.analyzeImage(
    imageFile: imageFile,
  );

  print(result.description);
} on VisionException catch (e) {
  print(e.message);
}
```

---

## Built-in Validations

Smart Vision automatically validates:

- Empty API keys
- Empty prompts
- Missing image files
- Empty image files
- Oversized image files
- Invalid AI responses
- Network failures
- Request timeouts

No additional validation is required.

---

## Architecture

The package follows a provider-based architecture.

```text
SmartVision
    │
    ▼
VisionConfig
    │
    ▼
VisionProvider
    │
    ▼
VisionServiceInterface
    │
 ┌──┼───────────────┬───────────────┐
 ▼  ▼               ▼               ▼
Gemini        OpenAI        Claude
Service       Service       Service
```

This architecture makes it easy to add new AI providers without changing the public API.

---

## Current Gemini Example

```dart
final vision = SmartVision(
  config: VisionConfig(
    apiKey: 'YOUR_GEMINI_API_KEY',
    provider: VisionProvider.gemini,
  ),
);

final result = await vision.analyzeImage(
  imageFile: imageFile,
);

print(result.description);
```

---

## Example Output

```text
A young woman is standing outdoors holding a bouquet of flowers. She is smiling and wearing a white dress. Trees and greenery can be seen in the background.
```

---

## Roadmap

### Version 0.1.0

- [x] Gemini support
- [x] VisionResult model
- [x] Error handling
- [x] Provider abstraction

### Future Releases

- [ ] OpenAI Vision support
- [ ] Claude Vision support
- [ ] HuggingFace Vision support
- [ ] Streaming responses
- [ ] Batch image analysis
- [ ] Response metadata
- [ ] Confidence scores

---

## Requirements

- Flutter 3.x+
- Dart 3.x+
- Valid AI provider API key

---

## Security Notes

Never commit API keys to source control.

Recommended approaches:

- Environment variables
- Flutter DotEnv
- Secure backend services
- Secret managers

Example:

```dart
final apiKey = dotenv.env['GEMINI_API_KEY'];
```

---

## Contributing

Contributions, issues, and feature requests are welcome.

Feel free to open an issue or submit a pull request.

---

## License

MIT License

---

Built with ❤️ for Flutter developers.