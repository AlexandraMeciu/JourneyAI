import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/chat_managers/chat_manager.dart';
import 'package:journal_app/chat_models/chat_session.dart';
import 'package:journal_app/database/data.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class ChatHistoryScreen extends StatelessWidget {
  final ChatManager manager;

  const ChatHistoryScreen({super.key, required this.manager});

  @override
  Widget build(BuildContext context) {
    final List<ChatSession> sessions = [...manager.sessions];

    sessions.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return UltraBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Journal History"),
        ),
        body: sessions.isEmpty
            ? Center(
                child: Text(
                  "No conversations yet.",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  final session = sessions[index];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.auto_stories),
                    ),
                    title: Text(
                      _formatDate(session.createdAt),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${session.messages.length} messages"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      manager.openSession(session);
                      Navigator.pop(context);
                    },
                  );
                },
                separatorBuilder: (_, __) => Divider(
                      height: 1,
                    ),
                itemCount: sessions.length),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();

    final difference = DateTime(today.year, today.month, today.day)
        .difference(DateTime(date.year, date.month, date.day));

    if (difference.inDays == 0) {
      return "Today";
    }

    if (difference.inDays == 1) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date);
    }

    return DateFormat.yMMMMd().format(date);
  }
}
