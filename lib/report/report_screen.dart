import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../presentation/widgets/ai_doctor_sheet.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? _image;
  bool _isScanning = false;

  void _pickAndScan() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);
    
    if (photo != null) {
      setState(() { _image = File(photo.path); _isScanning = true; });
      
      // Perform OCR
      final inputImage = InputImage.fromFilePath(photo.path);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      
      setState(() => _isScanning = false);

      if (!mounted) return;

      if (recognizedText.text.length < 10) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No text found. Try again.")));
        }
        return;
      }

      // 🚀 Launch AI Doctor Immediately
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AiDoctorSheet(
            contextData: recognizedText.text,
            initialPrompt: "Analyze this medical report. Explain the values, flag abnormal results, and suggest next steps.",
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab Report Decoder")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Preview Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: _image == null 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.document_scanner_rounded, size: 80, color: Colors.teal.shade200),
                        const SizedBox(height: 20),
                        const Text("Upload a Blood Report\nor Prescription", style: TextStyle(color: Colors.grey))
                      ],
                    )
                  : ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(_image!, fit: BoxFit.contain)),
              ),
            ),
            const SizedBox(height: 30),
            
            // Scan Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _pickAndScan,
                icon: _isScanning ? const SizedBox.shrink() : const Icon(Icons.upload_file),
                label: _isScanning 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("UPLOAD & ANALYZE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}