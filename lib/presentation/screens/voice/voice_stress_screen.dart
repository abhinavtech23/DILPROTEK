import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; // ✅ Added this
import 'dart:math';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final _recorder = AudioRecorder();
  bool _isRecording = false;
  double _stressScore = 0;
  String _status = "Tap mic to analyze";

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  void _toggle() async {
    if (_isRecording) {
      // Stop Recording
      await _recorder.stop();
      if (!mounted) return; // ✅ Safety Check

      setState(() {
        _isRecording = false;
        _status = "Processing Biomarkers...";
      });

      // Simulate AI Processing
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      setState(() {
        _stressScore = Random().nextInt(100).toDouble();
        _status = _stressScore > 50 ? "High Stress Detected" : "Normal Voice Pattern";
      });

    } else {
      // Start Recording
      if (await Permission.microphone.request().isGranted) {
        // ✅ FIX: Use a safe temporary directory
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/audio_temp.m4a';

        // Start recording to that path
        await _recorder.start(const RecordConfig(), path: path);

        if (!mounted) return;
        setState(() {
          _isRecording = true;
          _status = "Listening...";
        });
      } else {
         if (!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Microphone permission required")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vocal Biomarkers")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _stressScore / 100, 
                  strokeWidth: 10, 
                  color: Colors.red, 
                  backgroundColor: Colors.green.withOpacity(0.3)
                ),
                Text("${_stressScore.toInt()}", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            FloatingActionButton.large(
              onPressed: _toggle,
              backgroundColor: _isRecording ? Colors.red : Colors.teal,
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
            )
          ],
        ),
      ),
    );
  }
}