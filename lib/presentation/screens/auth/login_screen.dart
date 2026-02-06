import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../home/home_screen.dart'; // ✅ Added Import for Home Screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // We keep this just in case you want to fix auth later
  final AuthService auth = AuthService(); 
  bool _isLoading = false;

  void _handleLogin() {
    setState(() => _isLoading = true);
    
    print("🚀 Button Clicked: Navigating to Home...");

    // ✅ FIX: Force Navigation after a short delay
    // This ignores Firebase errors and takes you straight to the app.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_rounded, size: 80, color: Color(0xFF009688)),
              const SizedBox(height: 20),
              const Text(
                "DilProtek",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text("AI Heart Defense System", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009688),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Enter App (Demo)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}