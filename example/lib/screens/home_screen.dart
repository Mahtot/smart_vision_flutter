import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:example/widgets/actions_buttons_widget.dart';
import 'package:example/widgets/gemini_response_widget.dart';
import 'package:example/widgets/image_preview_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _prompt = 'Describe the content of this image briefly.';

  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  String? _base64Image;
  String? _geminiResponse;

  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);

    if (image == null) {
      debugPrint('No image selected.');
      return;
    }

    final file = File(image.path);

    final bytes = await file.readAsBytes();

    final base64Image = base64Encode(bytes);

    setState(() {
      _selectedImage = file;
      _base64Image = base64Image;
      _geminiResponse = null;
    });
  }

  Future<void> _analyseImageWithGemini() async {
    if (_base64Image == null) {
      debugPrint('No image selected.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiKey = dotenv.env['GEMINI_API_KEY'];

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite:generateContent?key=$apiKey',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': _prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': _base64Image,
                  },
                },
              ],
            },
          ],
        }),
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode != 200) {
        debugPrint('Gemini request failed.');
        return;
      }

      final data = jsonDecode(response.body);

      final text = data['candidates'][0]['content']['parts'][0]['text'];

      setState(() {
        _geminiResponse = text;
      });
    } catch (e) {
      debugPrint('Error: $e');
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
                onPressed: _isLoading ? null : _analyseImageWithGemini,
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Analyse Image with Gemini'),
              ),

              const SizedBox(height: 20),

              GeminiResponseWidget(geminiResponse: _geminiResponse),
            ],
          ),
        ),
      ),
    );
  }
}
