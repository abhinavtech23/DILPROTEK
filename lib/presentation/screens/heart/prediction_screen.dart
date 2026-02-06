import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../data/services/api_service.dart';

class HeartPredictionScreen extends StatefulWidget {
  const HeartPredictionScreen({super.key});
  @override
  State<HeartPredictionScreen> createState() => _HeartPredictionScreenState();
}

class _HeartPredictionScreenState extends State<HeartPredictionScreen> {
  // Inputs matching your CSV columns
  double age = 50, sex = 1, cp = 0, trtbps = 120, chol = 200, fbs = 0, restecg = 0, thalachh = 150, exng = 0, caa = 0;
  bool _loading = false;

  void _analyze() async {
    setState(() => _loading = true);
    final risk = await ApiService.predictHeartRisk({
      "age": age, "sex": sex, "cp": cp, "trtbps": trtbps, 
      "chol": chol, "fbs": fbs, "restecg": restecg, 
      "thalachh": thalachh, "exng": exng, "caa": caa
    });
    if (!mounted) return;
    setState(() => _loading = false);
    _showResult(risk);
  }

  void _showResult(double risk) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("${risk.toStringAsFixed(1)}% Risk", 
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, 
              color: risk > 50 ? Colors.red : Colors.green)),
            Expanded(
              child: ModelViewer(
                // ✅ Use a valid 3D model URL
                // If you have a local asset, use 'assets/heart.glb' and add it to pubspec.yaml
                src: 'assets/lowpoly_human_heart.glb', 
                
                // ❌ REMOVED: animationSpeed (This caused the error)
                
                // ✅ ADDED: autoPlay (Ensures the animation moves)
                autoPlay: true, 
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const Text("Digital Twin Simulation Active", style: TextStyle(color: Colors.grey))
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Predictor")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _slider("Age", age, 20, 100, (v) => age = v),
          _slider("Cholesterol", chol, 100, 400, (v) => chol = v),
          _slider("Max Heart Rate", thalachh, 60, 220, (v) => thalachh = v),
          _slider("Resting BP", trtbps, 80, 200, (v) => trtbps = v),
          const SizedBox(height: 10),
          const Text("Chest Pain (0=Typical, 3=Asymptomatic)"),
          Slider(value: cp, min: 0, max: 3, divisions: 3, label: cp.round().toString(), onChanged: (v) => setState(() => cp = v)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loading ? null : _analyze,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.all(15)),
            child: _loading ? const CircularProgressIndicator() : const Text("Analyze Risk"),
          )
        ],
      ),
    );
  }

  Widget _slider(String label, double val, double min, double max, Function(double) set) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ${val.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(value: val, min: min, max: max, onChanged: (v) => setState(() => set(v))),
      ],
    );
  }
}