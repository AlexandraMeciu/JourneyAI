import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/chat_managers/chat_manager.dart';
import 'package:journal_app/chat_models/journal_entry.dart';
import 'package:journal_app/database/plan_db.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/screens/journal_screen.dart';
import 'package:journal_app/screens/plan_screen.dart';
import 'package:journal_app/widgets/alert_box.dart';
import 'package:table_calendar/table_calendar.dart';

class BackView extends StatefulWidget {
  const BackView({
    super.key,
    required this.today,
    required this.chatManager,
  });

  final DateTime today;
  final ChatManager chatManager;

  @override
  State<BackView> createState() => _BackViewState();
}

class _BackViewState extends State<BackView> {
  DateTime today = DateTime.now();
  //PlanDataBase checkPlanDB = PlanDataBase();
  late final JournalEntry _journalEntry;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    nowTime = today;
    // checkPlanDB.loadPlanData();
  }

  bool dataCheck = false;
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    // focusedDay = today;
    //  checkPlanDB.loadPlanData();
    setState(() {
      today = day;
      nowTime = day;
    });
  }

  void cancelDialogBox() {
    Navigator.of(context).pop();
  }

  JournalEntry? _getJournalForDay(DateTime day) {
    final dayStr = DateFormat('yyyy-MM-dd').format(day);

    try {
      final session = widget.chatManager.sessions.firstWhere(
          (s) => DateFormat('yyyy-MM-dd').format(s.createdAt) == dayStr);
      return session.journalEntry;
    } catch (_) {
      return null;
    }
  }

  void _showJournal() {
    final journal = _getJournalForDay(today);

    if (journal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No journal entry for this day")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalScreen(journal: journal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff614385), Color(0xff516395)],
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 38,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2050, 3, 14),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                      color: Color.fromARGB(255, 162, 153, 175),
                      fontWeight: FontWeight.bold,
                    ),
                    weekdayStyle: TextStyle(
                      color: Colors.white,
                    )),
                calendarStyle: const CalendarStyle(
                  weekendTextStyle: TextStyle(
                    color: Color.fromARGB(255, 162, 153, 175),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  defaultTextStyle: TextStyle(
                    fontSize: 16,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 159, 43, 255),
                    shape: BoxShape.circle,
                  ),
                  outsideTextStyle: TextStyle(
                      color: Color.fromARGB(144, 0, 0, 0), fontSize: 16),
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: _onDaySelected,
              ),
            ),
            GestureDetector(
              onTap: _showJournal,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromARGB(214, 124, 77, 255),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  'Show Journal',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
