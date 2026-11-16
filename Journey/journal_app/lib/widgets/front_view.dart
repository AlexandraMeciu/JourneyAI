import 'package:flutter/material.dart';
import 'package:journal_app/database/plan_db.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/screens/chat_screen.dart';

// ignore: must_be_immutable
class FrontView extends StatelessWidget {
  FrontView({
    super.key,
  });

  // ignore: non_constant_identifier_names
  var MONTHS = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  var today = DateTime.now();
  PlanDataBase planDB = PlanDataBase();

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = getDaysInMonth(today.year, today.month);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(149, 0, 0, 0),
              Color.fromARGB(150, 57, 64, 131),
              Color.fromARGB(150, 7, 8, 13)
            ],
            stops: [0, 0.5, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color.fromARGB(125, 72, 0, 187), blurRadius: 30),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              today.day.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 35),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              MONTHS[today.month - 1],
              style: const TextStyle(color: Colors.white, fontSize: 40),
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    nowTime = DateTime.now();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (e) =>
                            const ChatScreen(), //AiTestScreen(), //PlanScreen(),
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: 70,
                    height: 70,
                    child: Icon(
                      Icons.add,
                      size: 70,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${today.day}/$daysInMonth',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Container(
                        width: double.infinity,
                        height: 3,
                        color: Colors.grey,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: today.day / daysInMonth,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
