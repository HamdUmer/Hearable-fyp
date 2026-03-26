import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LipReadingScreen extends StatefulWidget {
  const LipReadingScreen({super.key});

  @override
  State<LipReadingScreen> createState() => _LipReadingScreenState();
}

class _LipReadingScreenState extends State<LipReadingScreen> {
  String responseText = "Ask something...";
  final TextEditingController controller = TextEditingController();

  // ✅ Function to call backend chatbot API
  Future<void> sendMessage(String message) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/chat");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      final data = jsonDecode(res.body);

      setState(() {
        responseText = data["response"];
      });
    } catch (e) {
      setState(() {
        responseText = "Error connecting to backend: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Text(responseText, style: const TextStyle(fontSize: 22)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask something...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
