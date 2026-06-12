import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../data/services/api_service.dart';
import '../../widgets/ai_doctor_sheet.dart'; // Import the new widget

class HeartPredictionScreen extends StatefulWidget {
  const HeartPredictionScreen({super.key});
  @override
  State<HeartPredictionScreen> createState() => _HeartPredictionScreenState();
}

class _HeartPredictionScreenState extends State<HeartPredictionScreen> {
  // Default values
  double age = 50, chol = 200, thalachh = 150, trtbps = 120, cp = 0;
  bool _loading = false;

  void _analyze() async {
    setState(() => _loading = true);
    
    // 1. Get Prediction
    final risk = await ApiService.predictHeartRisk({
      "age": age, "sex": 1, "cp": cp, "trtbps": trtbps, 
      "chol": chol, "fbs": 0, "restecg": 0, "thalachh": thalachh, "exng": 0, "caa": 0
    });

    if (!mounted) return;
    setState(() => _loading = false);

    // 2. Show Result + Trigger AI
    _showResultDialog(risk);
  }

  void _showResultDialog(double risk) {
    bool isHighRisk = risk > 50;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // 3D Heart
            const SizedBox(height: 200, child: ModelViewer(
              src: 'assets/lowpoly_human_heart.glb',
              autoPlay: true, autoRotate: true, cameraControls: true,
              backgroundColor: Colors.transparent,
            )),
            
            Text("${risk.toStringAsFixed(1)}% Risk", 
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, 
              color: isHighRisk ? Colors.red : Colors.green)),
            
            const SizedBox(height: 10),
            Text(isHighRisk ? "Action Required" : "Heart is Healthy", 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            
            const Spacer(),
            
            // AI Doctor Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Get AI Doctor Advice"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  Navigator.pop(ctx); // Close current sheet
                  // Open AI Doctor
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => AiDoctorSheet(
                      contextData: "Patient Risk: $risk%. Age: $age. Chol: $chol.",
                      initialPrompt: "The patient has a $risk% heart disease risk. Provide a diet plan, exercise routine, and immediate precautions.",
                    )
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Predictor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard("Vitals", [
               _slider("Age", age, 20, 100, (v) => age = v),
               _slider("Resting BP", trtbps, 90, 200, (v) => trtbps = v),
               _slider("Cholesterol", chol, 120, 400, (v) => chol = v),
            ]),
            const SizedBox(height: 20),
            _buildCard("Heart Metrics", [
               _slider("Max Heart Rate", thalachh, 60, 220, (v) => thalachh = v),
               const Text("Chest Pain Type", style: TextStyle(fontWeight: FontWeight.bold)),
               Slider(value: cp, min: 0, max: 3, divisions: 3, label: ["Typical", "Atypical", "Non-anginal", "Asymptomatic"][cp.toInt()], onChanged: (v) => setState(() => cp = v)),
            ]),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _analyze,
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text("ANALYZE HEART RISK"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const Divider(),
            ...children
          ],
        ),
      ),
    );
  }

  Widget _slider(String label, double val, double min, double max, Function(double) set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(val.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
          ]),
          Slider(value: val, min: min, max: max, activeColor: Colors.teal, onChanged: (v) => setState(() => set(v))),
        ],
      ),
    );
  }
}