import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../data/services/api_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? _image;
  String _extractedText = "";
  String _aiAdvice = "";
  bool _isAnalyzing = false;

  final ImagePicker _picker = ImagePicker();

  // 1. Pick Image
  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
        _extractedText = "";
        _aiAdvice = "";
      });
      _processImage(photo.path);
    }
  }

  // 2. Read Text (OCR)
  Future<void> _processImage(String path) async {
    setState(() => _isAnalyzing = true);
    try {
      final inputImage = InputImage.fromFilePath(path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
      });

      // 3. Ask AI for Advice
      if (_extractedText.isNotEmpty) {
        _getAIAdvice(_extractedText);
      } else {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not read any text. Try a clearer photo.")),
        );
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      print("Error scanning: $e");
    }
  }

  // 4. Get AI Response
  Future<void> _getAIAdvice(String reportText) async {
    String prompt = "Analyze this medical report text and give a summary, key warnings, and advice: \n\n$reportText";
    
    // Uses your existing ApiService!
    String response = await ApiService.getChatResponse(prompt);
    
    setState(() {
      _aiAdvice = response;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medical Report AI"), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview Area
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload_file, size: 50, color: Colors.grey),
                          Text("Tap 'Upload' to scan a report"),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 20),
            
            // Upload Button
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Upload Report"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),

            const SizedBox(height: 30),

            // Results Section
            if (_isAnalyzing)
              const Center(child: CircularProgressIndicator())
            else if (_aiAdvice.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🤖 AI Analysis:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    const Divider(),
                    Text(_aiAdvice, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}