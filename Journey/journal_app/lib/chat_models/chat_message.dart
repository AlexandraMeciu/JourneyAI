import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 4)
enum MessageRole {
  @HiveField(0)
  system,
  @HiveField(1)
  user,
  @HiveField(2)
  assistant
}

@HiveType(typeId: 5)
class ChatMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final MessageRole role;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime timestamp;

  ChatMessage(
      {required this.id,
      required this.role,
      required this.content,
      required this.timestamp});

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;

//For Hive
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role": role.name,
      "content": content,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        id: json["id"],
        role: MessageRole.values
            .firstWhere(((element) => element.name == json["role"])),
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]));
  }

//for LM Studio
  Map<String, dynamic> toApiJson() {
    return {
      "role": role.name,
      "content": content,
    };
  }
}
