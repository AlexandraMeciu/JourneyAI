import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Odyssey is thinking...",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
