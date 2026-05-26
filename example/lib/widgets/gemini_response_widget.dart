import 'package:flutter/material.dart';

class GeminiResponseWidget extends StatelessWidget {
  final String? geminiResponse;

  const GeminiResponseWidget({
    super.key,
    required this.geminiResponse,
  });

  @override
  Widget build(BuildContext context) {
    if (geminiResponse == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        child: Text(
          geminiResponse!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}