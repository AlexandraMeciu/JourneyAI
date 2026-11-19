import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/ai/ai_service.dart';
import 'package:journal_app/chat_managers/chat_manager.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/screens/chat_history_screen.dart';
import 'package:journal_app/screens/journal_screen.dart';
import 'package:journal_app/widgets/chat/empty_conversation.dart';
import 'package:journal_app/widgets/chat/message_bubble.dart';
import 'package:journal_app/widgets/chat/message_input.dart';
import 'package:journal_app/widgets/chat/typing_indicator.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatManager _manager;
  var date = DateFormat.yMMMEd().format(nowTime);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _manager = ChatManager(AiService());

    _manager.addListener(_onChatUpdated);
//    _manager.createNewSession();

    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _manager.startConversation();
    });*/
  }

  void _onChatUpdated() {
    if (!mounted) return;

    /*if (kDebugMode) {
      print("UI sees ${_manager.currentSession.messages.length} messages");
    }*/

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 250), curve: Curves.easeOutBack);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _manager.removeListener(_onChatUpdated);
    _manager.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (_manager.currentSession.messages.isEmpty) {
      return EmptyConversation();
    }

    return _buildMessageList();
  }

  Widget _buildMessageList() {
    final messages = _manager.currentSession.messages;

    /* if (kDebugMode) {
      print("Building ${messages.length} bubbles");
    }*/

    return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 12),
        itemCount: messages.length + (_manager.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (_manager.isLoading && index == messages.length) {
            return TypingIndicator();
          }

          return MessageBubble(message: messages[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    // final messages = _manager.session.messages;
    final isLoading = _manager.isLoading;
    return UltraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(date),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChatHistoryScreen(manager: _manager)));
                },
                icon: Icon(Icons.history)),
            IconButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        /*  if (_manager.currentSession.journalEntry == null) {
                    await _manager.generateJournal();
                  }*/

                        if (_manager.currentSession.messages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Write something first")));
                          return;
                        }

                        await _manager.generateJournal();
                        if (!mounted) return;

                        final journal = _manager.currentSession.journalEntry;

                        if (journal == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Couldn't generate journal")));
                          return;
                        }

                        if (!context.mounted) return;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    JournalScreen(journal: journal)));
                      },
                icon: isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.auto_awesome)),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildBody()),
            MessageInput(
                onSend: _manager.sendMessage, enabled: !_manager.isLoading)
          ],
        ),
      ),
    );
  }
}
