import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:journal_app/chat_models/chat_message.dart';
import 'package:journal_app/chat_models/chat_session.dart';
import 'package:journal_app/chat_models/journal_entry.dart';

import 'prompts.dart';
import 'ai_config.dart';

class AiService {
  AiService();

  Future<String> generateWelcomeMessage() async {
    return _sendRequest(messages: [
      {
        "role": "system",
        "content": AIPrompts.systemPrompt,
      },
      {
        "role": "user",
        "content": AIPrompts.firstMessage,
      },
    ]);
    /*  if (kDebugMode) {
      print("Generative Welcome Message");
    }
    final response = await http.post(Uri.parse(AIConfig.baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AIConfig.apiKey}",
        },
        body: jsonEncode({
          "model": AIConfig.model,
          "messages": [
            {
              "role": "system",
              "content": AIPrompts.systemPrompt,
            },
            {
              "role": "user",
              "content": AIPrompts.firstMessage,
            }
          ],
          "temperature": AIConfig.temperature,
          "max_tokens": AIConfig.maxTokens,
          "chat_template_kwargs": {
            "enable_thinking": false,
          }
        }));

    if (kDebugMode) {
      print("Status: ${response.statusCode}");
    }
    if (kDebugMode) {
      print(response.body);
    }
    final json = jsonDecode(response.body);
    if (kDebugMode) {
      print("Json: $json");
    }
    return json["choices"][0]["message"]["content"];*/
  }

  /* Future<String> sendMessage({
    required List<ChatMessage> messages,
  }) async {
    /* if (kDebugMode) {
      print("Send Message");
    }
    final requestMessage = [
      {
        "role": "system",
        "content": AIPrompts.systemPrompt,
      },
      ...messages.map((messages) => messages.toJson())
    ];

    final response = await http.post(Uri.parse(AIConfig.baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AIConfig.apiKey}",
        },
        body: jsonEncode({
          "model": AIConfig.model,
          "messages": requestMessage,
          "temperature": temperature ?? AIConfig.temperature,
          "max_tokens": maxTokens ?? AIConfig.maxTokens,
          "chat_template_kwargs": {
            "enable_thinking": false,
          }
        }));

    if (kDebugMode) {
      print("Status: ${response.statusCode}");
    }
    if (kDebugMode) {
      print(response.body);
    }
    final json = jsonDecode(response.body);
    if (kDebugMode) {
      print("Json: $json");
    }
    return json["choices"][0]["message"]["content"];*/

    final requesMessages = [
      {
        "role": "system",
        "content": AIPrompts.systemPrompt,
      },
      ...messages.map((e) => e.toApiJson()),
    ];
    return _sendRequest(messages: requesMessages);
  }*/

  Future<String> _sendRequest(
      {required List<Map<String, dynamic>> messages}) async {
    try {
      final response = await http
          .post(Uri.parse(AIConfig.baseUrl),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${AIConfig.apiKey}",
              },
              body: jsonEncode({
                "model": AIConfig.model,
                "messages": messages,
                "temperature": AIConfig.temperature,
                "max_tokens": AIConfig.maxTokens,
                // "think": false
                "chat_template_kwargs": {
                  "enable_thinking": false,
                }
              }))
          .timeout(Duration(seconds: 300));

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      final json = jsonDecode(response.body);
      final content = json["choices"]?[0]?["message"]?["content"];

      if (content == null || content.toString().trim().isEmpty) {
        throw Exception("The AI returned an empty response.");
      }

      return content.toString();
    } catch (e, stackTrace) {
      debugPrint("========== AI ERROR ==========");
      debugPrint("Error: $e");
      debugPrint("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<String> sendMessage({required List<ChatMessage> messages}) async {
    final request = [
      {
        "role": "system",
        "content": AIPrompts.systemPrompt,
      },
      ...messages.map((m) => m.toJson())
    ];

    return _sendRequest(messages: request);
  }

  Future<JournalEntry> generateJournal(ChatSession session) async {
    final conversation = StringBuffer();

    for (final message in session.messages) {
      conversation.writeln("${message.role.name}: ${message.content}");
    }

    // ← ADD THIS
    debugPrint("========== CONVERSATION BEING SENT ==========");
    debugPrint(conversation.toString());
    debugPrint("Message count: ${session.messages.length}");
    debugPrint("=============================================");

    final response = await _sendRequest(messages: [
      {
        "role": "system",
        "content": AIPrompts.systemPrompt,
      },
      {
        "role": "user",
        "content": AIPrompts.summaryPrompt(
          conversation.toString(),
        ),
      },
    ]);

    debugPrint("========== JOURNAL RESPONSE ==========");
    debugPrint(response);
    debugPrint("=====================================");

    return _parseJournal(response, session);
  }

  JournalEntry _parseJournal(String response, ChatSession session) {
    String title = "";
    String reflection = "";
    String gratitude = "";
    String tomorrow = "";

    final lines = response.split('\n');

    String currentSection = "";

    for (final line in lines) {
      final text = line.trim();

      if (text.startsWith("Title:")) {
        currentSection = "title";
        title = text.replaceFirst("Title:", "").trim();
        continue;
      }

      if (text.startsWith("Reflection:")) {
        currentSection = "reflection";
        reflection = text.replaceFirst("Reflection:", "").trim();
        continue;
      }

      if (text.startsWith("Gratitude:")) {
        currentSection = "gratitude";
        gratitude = text.replaceFirst("Gratitude:", "").trim();
        continue;
      }

      if (text.startsWith("Tomorrow")) {
        currentSection = "tomorrow";
        tomorrow = text.replaceFirst("Tomorrow:", "").trim();
        continue;
      }

      switch (currentSection) {
        case "reflection":
          reflection += "\n$text";
          break;
        case "gratitude":
          gratitude += "\n$text";
          break;

        case "tomorrow":
          tomorrow += "\n$text";
          break;
      }
    }

    return JournalEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sessionId: session.id,
        createdAt: DateTime.now(),
        title: title,
        reflection: reflection.trim(),
        gratitude: gratitude.trim(),
        tomorrow: tomorrow.trim());
  }
}
