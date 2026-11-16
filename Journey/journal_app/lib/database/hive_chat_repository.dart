import 'package:journal_app/chat_models/chat_session.dart';
import 'package:journal_app/repository/chat_repository.dart';

class HiveChatRepository implements ChatRepository {
  @override
  Future<void> deleteSession(String id) async {
    // TODO: implement deleteSession
  }

  @override
  Future<List<ChatSession>> getAllSessions() async {
    // TODO: implement getAllSessions
    return [];
  }

  @override
  Future<ChatSession?> getSession(String id) async {
    // TODO: implement getSession
    return null;
  }

  @override
  Future<void> saveSession(ChatSession session) async {
    // TODO: implement saveSession
  }
}
