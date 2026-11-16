import 'package:flutter/material.dart';
import 'package:journal_app/chat_models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: isUser
                ? Colors.blueGrey.shade700
                : Colors.grey.shade900.withAlpha(180),
            borderRadius: BorderRadius.circular(18)),
        child: Text(
          message.content,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
