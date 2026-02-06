import 'dart:math';

class StressAiService {
  
  
  Future<Map<String, dynamic>> analyzeStress(String audioPath) async {
   await Future.delayed(const Duration(seconds: 3));
    final random = Random();
    int stressScore = 20 + random.nextInt(60);
    
    String label;
    if (stressScore < 40) {
      label = "Low Stress (Calm)";
    } else if (stressScore < 70) {
      label = "Moderate Stress";
    } else {
      label = "High Stress Detected";
    }

    return {
      "score": stressScore,
      "label": label,
      "biomarkers": {
        // Simulating technical biomarker data for the UI
        "jitter": "${(0.3 + random.nextDouble()).toStringAsFixed(2)}%", 
        "shimmer": "${(1.5 + random.nextDouble()).toStringAsFixed(2)}dB",
        "pitch_variability": "${(10 + random.nextInt(20))}Hz"
      }
    };
  }
}