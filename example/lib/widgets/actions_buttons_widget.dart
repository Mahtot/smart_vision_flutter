import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActionButtonsWidget extends StatelessWidget {
  final void Function(ImageSource source) onPickImage;

  const ActionButtonsWidget({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => onPickImage(ImageSource.camera),
          icon: const Icon(Icons.camera_alt_rounded),
          label: const Text('Camera'),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => onPickImage(ImageSource.gallery),
          icon: const Icon(Icons.image_rounded),
          label: const Text('Gallery'),
        ),
      ],
    );
  }
}
