import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  
  // Use your PC's LAN IP so the physical device can reach the backend
  // (127.0.0.1 only works on the PC itself, not from your phone)
  static const String _pythonBackendUrl = "http://192.168.29.37:5000/predict";
  static const String _deepSeekUrl = "https://openrouter.ai/api/v1/chat/completions";
  static const String _deepSeekKey = "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";

  static Future<double> predictHeartRisk(Map<String, double> data) async {
    try {
      debugPrint("Connecting to: $_pythonBackendUrl");
      debugPrint("Sending Data: $data");

      final response = await http.post(
        Uri.parse(_pythonBackendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 5)); 

      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return (body['risk_score'] as num).toDouble();
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Connection Failed. Using Fallback. Error: $e");
      return _fallbackCalculation(data);
    }
  }

  static Future<String> getChatResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse(_deepSeekUrl),
        headers: {
          "Authorization": "Bearer $_deepSeekKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-r1",
          "messages": [
            {"role": "system", "content": "You are DilProtek, a cardiac assistant. Be brief."},
            {"role": "user", "content": query}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['choices'] != null && (data['choices'] as List).isNotEmpty) {
           return data['choices'][0]['message']['content'];
        }
      }
      return "I am currently offline. Please check connection.";
    } catch (e) {
      return "Connection Error: $e";
    }
  }

  static double _fallbackCalculation(Map<String, double> d) {
    double score = 10;
    if ((d['cp'] ?? 0) > 0) score += 20; // ✅ Added ?? 0 for safety
    if ((d['chol'] ?? 0) > 240) score += 15;
    if ((d['age'] ?? 0) > 50) score += 15;
    return score > 99 ? 99 : score;
  }
}