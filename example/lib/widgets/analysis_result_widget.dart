import 'package:flutter/material.dart';

class AnalysisResultWidget extends StatelessWidget {
  final String? analysisResult;

  const AnalysisResultWidget({
    super.key,
    required this.analysisResult,
  });

  @override
  Widget build(BuildContext context) {
    if (analysisResult == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        child: Text(
          analysisResult!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}