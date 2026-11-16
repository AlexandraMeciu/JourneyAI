import 'package:hive/hive.dart';
import 'package:journal_app/chat_models/chat_message.dart';
import 'package:journal_app/chat_models/journal_entry.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 3)
class ChatSession {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final List<ChatMessage> messages;
  @HiveField(4)
  JournalEntry? journalEntry;

  ChatSession(
      {required this.id,
      required this.createdAt,
      required this.messages,
      required this.title,
      this.journalEntry});

  bool get isEmpty => messages.isEmpty;
  bool get isNotEmpty => messages.isNotEmpty;
  int get messagesCount => messages.length;

  void addMessages(ChatMessage message) {
    messages.add(message);
  }

  void clear() {
    messages.clear();
  }

  /*List<Map<String, dynamic>> toJson() {
    return messages.map((message) => message.toApiJson()).toList();
  }*/

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt.toIso8601String(),
      "messages": messages.map((e) => e.toJson()).toList()
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        messages: (json["messages"] as List)
            .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        title: json["title"]);
  }
}
