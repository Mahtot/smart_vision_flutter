import 'dart:io';
import 'package:flutter/material.dart';

import 'package:example/widgets/actions_buttons_widget.dart';
import 'package:example/widgets/analysis_result_widget.dart';
import 'package:example/widgets/image_preview_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_vision_flutter/smart_vision_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  String? _analysisResult;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);

    if (image == null) {
      debugPrint('No image selected.');
      return;
    }

    setState(() {
      _selectedImage = File(image.path);
      _analysisResult = null;
    });
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      setState(() {
        _analysisResult = 'Please select an image first.';
      });
      return;
    }

    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.trim().isEmpty) {
      debugPrint(' API key is missing.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await SmartVision.analyzeImage(
        imageFile: _selectedImage!,
        provider: VisionProvider.gemini,
        apiKey: apiKey,
      );

      setState(() {
        _analysisResult = result.description;
      });
    } on VisionException catch (e) {
      debugPrint(e.toString());

      setState(() {
        _analysisResult = e.message;
      });
    } catch (e) {
      debugPrint('Unexpected error: $e');

      setState(() {
        _analysisResult = 'Something went wrong. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: const Text('Smart Vision Example'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagePreviewWidget(selectedImage: _selectedImage),
              const SizedBox(height: 20),
              ActionButtonsWidget(onPickImage: _pickImage),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isLoading ? null : _analyzeImage,
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Analyze Image'),
              ),
              const SizedBox(height: 20),
              AnalysisResultWidget(analysisResult: _analysisResult),
            ],
          ),
        ),
      ),
    );
  }
}
