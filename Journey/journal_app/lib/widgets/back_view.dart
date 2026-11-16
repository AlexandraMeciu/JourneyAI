import 'package:flutter/material.dart';
import 'package:journal_app/database/plan_db.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/screens/plan_screen.dart';
import 'package:journal_app/widgets/alert_box.dart';
import 'package:table_calendar/table_calendar.dart';

class BackView extends StatefulWidget {
  const BackView({
    super.key,
    required this.today,
  });

  final DateTime today;

  @override
  State<BackView> createState() => _BackViewState();
}

class _BackViewState extends State<BackView> {
  DateTime today = DateTime.now();
  PlanDataBase checkPlanDB = PlanDataBase();

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    nowTime = today;
    checkPlanDB.loadPlanData();
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
              onTap: () {
                for (int i = 0; i < checkPlanDB.todaysPlanList.length; i++) {
                  if (convertDateTimeToString(nowTime) ==
                      checkPlanDB.todaysPlanList[i][0]) {
                    dataCheck = false;
                    selectionIndex = i;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (e) => const PlanScreen(),
                      ),
                    );
                    break;
                  } else {
                    dataCheck = true;
                  }
                }
                if (dataCheck == true) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertBox(onClose: cancelDialogBox);
                      });
                }
              },
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromARGB(214, 124, 77, 255),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  'Show info',
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
