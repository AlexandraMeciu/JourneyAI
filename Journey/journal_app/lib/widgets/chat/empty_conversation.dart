import 'package:flutter/material.dart';

class EmptyConversation extends StatelessWidget {
  const EmptyConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 62,
              color: Colors.white54,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Take a moment.",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "What's on your mind today?\n\n"
              "Start writing below and Odyssey will help you reflect.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
