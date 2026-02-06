import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _ctrl = TextEditingController();
  final List<Map<String, String>> _msgs = [];

  void _send() async {
    final text = _ctrl.text;
    if (text.isEmpty) return;
    setState(() {
      _msgs.add({"role": "user", "text": text});
      _ctrl.clear();
    });
    
    final reply = await ApiService.getChatResponse(text);
    setState(() {
      _msgs.add({"role": "ai", "text": reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Cardiac Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _msgs.length,
              itemBuilder: (_, i) => Align(
                alignment: _msgs[i]['role'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _msgs[i]['role'] == 'user' ? Colors.teal : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(_msgs[i]['text']!, 
                    style: TextStyle(color: _msgs[i]['role'] == 'user' ? Colors.white : Colors.black)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: "Ask..."))),
                IconButton(onPressed: _send, icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}