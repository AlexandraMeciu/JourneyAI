import 'package:flutter/material.dart';

import '../ai/ai_service.dart';
import '../chat_models/chat_message.dart';

class AiTestScreen extends StatefulWidget {
  const AiTestScreen({super.key});

  @override
  State<AiTestScreen> createState() => _AiTestScreenState();
}

class _AiTestScreenState extends State<AiTestScreen> {
  final AiService _ai = AiService();

  final TextEditingController _controller = TextEditingController();

  String _response = "";

  bool _loading = false;

  Future<void> _send() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
    });

    try {
      final response = await _ai.sendMessage(messages: [
        ChatMessage(
            id: "1",
            role: MessageRole.user,
            content: _controller.text,
            timestamp: DateTime.now())
      ]);
      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _response = e.toString();
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Odyssey AI Test"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Type something..."),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: _loading ? null : _send,
                child: _loading ? CircularProgressIndicator() : Text("Send"))
          ],
        ),
      ),
    );
  }
}
