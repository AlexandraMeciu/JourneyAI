import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/chat_models/journal_entry.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class JournalScreen extends StatelessWidget {
  final JournalEntry journal;

  const JournalScreen({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Journal"),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  journal.title,
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat.yMMMMd().format(journal.createdAt),
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(
                  height: 30,
                ),
                _Section(
                  title: "Reflection",
                  text: journal.reflection,
                ),
                SizedBox(
                  height: 24,
                ),
                _Section(
                  title: "Gratitude",
                  text: journal.gratitude,
                ),
                SizedBox(
                  height: 24,
                ),
                _Section(
                  title: "Tomorrow",
                  text: journal.tomorrow,
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            )),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String text;

  const _Section({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 17, color: Colors.white, height: 1.5),
        )
      ],
    );
  }
}
