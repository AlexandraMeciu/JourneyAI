import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/chat_models/chat_session.dart';

final _chatBox = Hive.box("dataBox");

class ChatDataBase {
  static String sessionsKey = "CHAT_SESSIONS";

  List<ChatSession> sessions = [];

  //load all the conversations

  void loadChatData() {
    final data = _chatBox.get(sessionsKey);

    if (data == null) {
      sessions = [];
      return;
    }

    sessions = List<ChatSession>.from(data);
    if (kDebugMode) {
      print("Load ${sessions.length} sessions");
    }

    /* sessions = (data as List)
        .map(((e) => ChatSession.fromJson(Map<String, dynamic>.from(e))))
        .toList();*/
  }

  //save all the conversations
  void updateChatDB() {
    // final json = sessions.map((session) => session.toJson()).toList();

    _chatBox.put(sessionsKey, sessions);

    if (kDebugMode) {
      print("Saved ${sessions.length} sessions");
    }
  }

  //add a new session

  void addSession(ChatSession session) {
    sessions.add(session);
    updateChatDB();
  }

  //update an existent session
  void updateSession(ChatSession session) {
    final index = sessions.indexWhere((element) => element.id == session.id);

    if (index == -1) {
      addSession(session);
    } else {
      sessions[index] = session;
    }
    updateChatDB();
  }

  //delete a session
  void deleteSession(String id) {
    sessions.removeWhere((element) => element.id == id);
    updateChatDB();
  }

  //search a sesssion
  ChatSession? getSession(String id) {
    try {
      return sessions.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  // delete all conversations
  void clearAll() {
    sessions.clear();
    updateChatDB();
  }
}
