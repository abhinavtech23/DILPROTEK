import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DigitalHeartTwin extends StatelessWidget {
  final double riskScore; // 0 to 100

  const DigitalHeartTwin({super.key, required this.riskScore});

  @override
  Widget build(BuildContext context) {
    // 🧠 Visualization Logic:
    // If risk is High (>50%), make background red-tinted.
    Color bgColor = riskScore > 50 
        ? Colors.red.withValues(alpha: 0.1) 
        : Colors.blue.withValues(alpha: 0.1);

    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: riskScore > 50 ? Colors.red.withValues(alpha: 0.3) : Colors.teal.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ModelViewer(
              // ✅ SRC: Use your local asset if you have it, otherwise use this web fallback
              src: 'assets/lowpoly_human_heart.glb', 
              // Fallback URL if local file is missing:
              // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
              
              alt: "Digital Twin of Heart",
              ar: true,
              autoRotate: true,
              autoPlay: true, // ✅ Ensures animation plays
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          
          // Data Overlay
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.monitor_heart, 
                    color: riskScore > 50 ? Colors.red : Colors.greenAccent, 
                    size: 20
                  ),
                  const SizedBox(width: 8),
                  Text(
                    riskScore > 50 ? "High Strain Detected" : "Optimal Rhythm",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}