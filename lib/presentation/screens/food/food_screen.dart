import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../../data/repositories/food_repository.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});
  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  CameraController? _cam;
  final _repo = FoodRepository();
  final _labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6));
  bool _scanning = false;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    // ✅ FIX 1: Changed '_repo.load()' to '_repo.loadCsv()'
    _repo.loadCsv(); 
    _initCam();
  }

  @override
  void dispose() {
    _cam?.dispose();
    _labeler.close();
    super.dispose();
  }

  void _initCam() async {
    final cams = await availableCameras();
    if (cams.isEmpty) return;
    
    _cam = CameraController(cams[0], ResolutionPreset.medium, enableAudio: false);
    await _cam!.initialize();
    if (mounted) setState(() {});
  }

  void _scan() async {
    if (_scanning || _cam == null || !_cam!.value.isInitialized) return;
    setState(() => _scanning = true);

    try {
      final img = await _cam!.takePicture();
      final inputImg = InputImage.fromFilePath(img.path);
      final labels = await _labeler.processImage(inputImg);

      Map<String, dynamic>? match;
      for (var l in labels) {
        // ✅ FIX 2: Changed '_repo.search()' to '_repo.findFood()'
        match = _repo.findFood(l.label);
        if (match != null) break; 
      }
      
      if (!mounted) return;

      setState(() => _result = match);
      
      if (match == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food not found in database. Try moving closer."))
        );
      }

    } catch (e) {
      print("Scan Error: $e");
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cam == null || !_cam!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Food Scanner")),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_cam!)),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                if (_result != null) ...[
                  Text(_result!['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _stat("Sodium", "${_result!['sodium']}mg", isBad: (_result!['sodium'] as num) > 500),
                    _stat("Cholesterol", "${_result!['chol']}mg", isBad: (_result!['chol'] as num) > 100),
                  ]),
                  if ((_result!['sodium'] as num) > 500)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("⚠️ High Sodium: Limit intake.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    )
                ] else const Text("Point at food and scan"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _scan, 
                  child: Text(_scanning ? "Analyzing..." : "Scan Food")
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _stat(String label, String val, {bool isBad = false}) {
    return Column(children: [
      Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isBad ? Colors.red : Colors.green)),
      Text(label, style: const TextStyle(color: Colors.grey))
    ]);
  }
}