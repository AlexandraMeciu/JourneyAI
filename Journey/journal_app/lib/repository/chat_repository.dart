import 'package:journal_app/chat_models/chat_session.dart';

abstract class ChatRepository {
  Future<void> saveSession(ChatSession session);

  Future<void> deleteSession(String id);

  Future<ChatSession?> getSession(String id);

  Future<List<ChatSession>> getAllSessions();
}
