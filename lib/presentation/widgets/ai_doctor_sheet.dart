import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/services/api_service.dart';

class AiDoctorSheet extends StatefulWidget {
  final String contextData; // The Report text or Heart Risk data
  final String initialPrompt; // "Analyze this..."

  const AiDoctorSheet({super.key, required this.contextData, required this.initialPrompt});

  @override
  State<AiDoctorSheet> createState() => _AiDoctorSheetState();
}

class _AiDoctorSheetState extends State<AiDoctorSheet> {
  String _response = "";
  bool _isLoading = true;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getInitialAdvice();
  }

  void _getInitialAdvice() async {
    final advice = await ApiService.getChatResponse("${widget.initialPrompt}\n\nData: ${widget.contextData}");
    if (mounted) {
      setState(() {
        _response = advice;
        _isLoading = false;
      });
    }
  }

  void _askFollowUp() async {
    if (_chatController.text.isEmpty) return;
    final question = _chatController.text;
    setState(() {
      _response += "\n\n**You:** $question\n\n**Dr. AI:** ...thinking...";
      _chatController.clear();
    });
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });

    final answer = await ApiService.getChatResponse("Context: ${widget.contextData}\n\nPrevious Advice: $_response\n\nUser Question: $question");
    
    if (mounted) {
      setState(() {
        _response = _response.replaceAll("...thinking...", answer);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // 🟢 Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.medical_services_outlined, color: Colors.white),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dr. DilProtek AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Always consult a real doctor", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))
              ],
            ),
          ),

          // 💬 Chat Area
          Expanded(
            child: _isLoading 
              ? const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Analyzing medical data..."),
                  ],
                ))
              : SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: MarkdownBody(data: _response, styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))),
                ),
          ),

          // ⌨️ Input Area
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: "Ask a follow-up question...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _askFollowUp,
                  mini: true,
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}