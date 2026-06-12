import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    
    // ✅ Real Authentication
    final user = await _auth.signInAnonymously();
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (user != null) {
        // Success
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Login Failed. Check Internet."),
            backgroundColor: Colors.red,
            action: SnackBarAction(label: "Retry", textColor: Colors.white, onPressed: _handleLogin),
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Full colored background
      body: Stack(
        children: [
          // Background Design
          Positioned(
            top: -100, right: -100,
            child: CircleAvatar(radius: 200, backgroundColor: Colors.white.withValues(alpha: 0.1)),
          ),
          
          Center(
            child: Card(
              margin: const EdgeInsets.all(30),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_rounded, size: 80, color: Colors.teal),
                    const SizedBox(height: 20),
                    const Text("DilProtek", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const Text("AI-Powered Cardiac Guard", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 40),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : const Text("Start Protection"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("By continuing, you agree to our Terms.", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}