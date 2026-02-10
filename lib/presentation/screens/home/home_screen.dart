import 'package:dilprotek/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



// ⚠️ THESE IMPORTS MUST MATCH YOUR ACTUAL FILE NAMES
// If any line below is red, it means that specific file is missing or named differently.
import '../heart/prediction_screen.dart';
import '../food/food_screen.dart';
import '../voice/voice_stress_screen.dart';
import '../doctor/doctor_connect_screen.dart';
import '../chatbot/ai_chat_screen.dart';
import '../auth/login_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("DilProtek", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // ✅ Sign out safely
              await FirebaseAuth.instance.signOut();
              
              // ✅ Check if the screen is still valid before navigating
              if (context.mounted) {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => const LoginScreen())
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _mainCard(context),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _btn(context, "Voice Stress", Icons.mic, Colors.purple, const VoiceScreen()),
                _btn(context, "Food Scanner", Icons.camera_alt, Colors.orange, const FoodScreen()),
                _btn(context, "Doctor Link", Icons.security, Colors.blue, const DoctorConnectScreen()),
                _btn(context, "AI Chat", Icons.chat, Colors.green, const AiChatScreen()),
                _btn(context, "Report AI", Icons.analytics, Colors.blue, const ReportScreen()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _mainCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HeartPredictionScreen())),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6F61), // Coral color
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10)]
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Heart Risk Predictor", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Tap to analyze vitals", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Icon(Icons.monitor_heart, color: Colors.white, size: 50)
          ],
        ),
      ),
    );
  }

  Widget _btn(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}