import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/ai/ai_service.dart';
import 'package:journal_app/chat_models/chat_message.dart';
import 'package:journal_app/chat_models/chat_session.dart';
import 'package:journal_app/database/chat_db.dart';

class ChatManager extends ChangeNotifier {
  ChatManager(this._aiService) {
    _chatDB.loadChatData();
    createNewSession();
  }
  final AiService _aiService;

  late ChatSession _session;

  bool _isLoading = false;

  ChatSession get currentSession => _session;

  bool get isLoading => _isLoading;
  final ChatDataBase _chatDB = ChatDataBase();

  List<ChatSession> get sessions => _chatDB.sessions;

  Future<void> createNewSession() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final existing = _chatDB.sessions.where(((element) =>
        DateFormat('yyyy-MM-dd').format(element.createdAt) == today));
    if (existing.isNotEmpty) {
      _session = existing.first;
      notifyListeners();
      return;
    }

    _session = ChatSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        messages: [],
        title: "Today's Reflection");

    _chatDB.addSession(_session);

    notifyListeners();
  }

  void newSession() {
    createNewSession();
    notifyListeners();
  }

  void _addMessage({required MessageRole role, required String content}) {
    _session.addMessages(ChatMessage(
        id: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        role: role,
        content: content,
        timestamp: DateTime.now()));
    /* if (kDebugMode) {
      print("Messages after user: ${_session.messages.length}");
    }*/
    _chatDB.updateSession(_session);
  }

  void openSession(ChatSession session) {
    _session = session;
    notifyListeners();
  }

  Future<void> startConversation() async {
    if (_session.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _aiService.generateWelcomeMessage();

      _session.addMessages(ChatMessage(
          id: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          role: MessageRole.assistant,
          content: response,
          timestamp: DateTime.now()));
      /*  if (kDebugMode) {
        print("Messages after AI: ${_session.messages.length}");
      }*/
      _chatDB.updateSession(_session);
    } catch (_) {
      _session.addMessages(ChatMessage(
          id: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          role: MessageRole.assistant,
          content: "Sorry, I couldn't start today's journaling session.",
          timestamp: DateTime.now()));
      /*  if (kDebugMode) {
        print("Messages catch error: ${_session.messages.length}");
      }*/
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _addMessage(role: MessageRole.user, content: text);
    notifyListeners();
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await _aiService.sendMessage(messages: currentSession.messages);
      if (kDebugMode) {
        print("Response $response");
      }
      _addMessage(role: MessageRole.assistant, content: response);
      _isLoading = false;
      notifyListeners();
    } catch (_) {
      _addMessage(
          role: MessageRole.assistant,
          content: "Sorry, I couldn't generate a response.");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> generateJournal() async {
    final journal = await _aiService.generateJournal(_session);

    _session.journalEntry = journal;

    _chatDB.updateSession(_session);

    notifyListeners();

    /* if (_session.messages.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      //  final journal = await _aiService.generateJournal(_session);

      _session.journalEntry = await _aiService.generateJournal(_session);

      _chatDB.updateSession(_session);
      debugPrint("Journal saved");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }*/
  }
}
