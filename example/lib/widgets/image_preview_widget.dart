import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File? selectedImage;

  const ImagePreviewWidget({super.key, required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    if (selectedImage == null) {
      return const Text('No image selected.');
    }

    return Card(
      child: Image.file(
        selectedImage!,
        width: 220,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}
