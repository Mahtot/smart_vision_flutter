import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

final themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 200, 100, 105),
  ),
);

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final imagePicker = ImagePicker();
  File? _selectedImage;

  void _onPickImage(ImageSource source) async {
    final image = await imagePicker.pickImage(source: source);
    if (image == null) return;

    File file = File(image.path);

    final int imageSize = await file.length();

    print('Image Path: ${image.path}');
    print('Image Size: $imageSize');
    print('Image Name: ${image.name}');

    setState(() {
      _selectedImage = file;
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          title: const Text('Smart Vision Example'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Card(
                  child: Image.file(_selectedImage!, width: 200, height: 200),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _onPickImage(ImageSource.camera);
                    },
                    label: Text('Camera'),
                    icon: Icon(Icons.camera_alt_rounded),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    label: Text('Gallery'),
                    icon: Icon(Icons.image_rounded),
                    onPressed: () {
                      _onPickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
