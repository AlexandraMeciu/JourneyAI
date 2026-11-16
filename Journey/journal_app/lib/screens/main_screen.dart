import 'package:flutter/material.dart';
import 'package:journal_app/screens/diary_screen.dart';
import 'package:journal_app/screens/habit_screen.dart';
import 'package:journal_app/screens/settings_screen.dart';
import 'package:journal_app/screens/to_do_list_screen.dart';
import 'package:journal_app/utilities/data_saved.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;

  @override
  void initState() {
    DataSaved().loadDate();
    super.initState();
  }

  List<Widget> pages = const [
    DiaryMain(),
    ToDoListScreen(),
    HabitScreen(),
    NotificationScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: pages[currentPage],
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: 1, top: 2), //const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(127, 0, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: NavigationBar(
                backgroundColor: Colors.transparent,
                onDestinationSelected: (int index) {
                  setState(
                    () {
                      currentPage = index;
                    },
                  );
                },
                selectedIndex: currentPage,
                indicatorColor: Color.fromARGB(255, 125, 113, 255),
                indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                height: 66,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      Icons.auto_stories,
                      size: 28,
                    ),
                    label: 'Diary',
                  ),
                  NavigationDestination(
                      icon: Icon(
                        Icons.developer_board,
                        size: 28,
                      ),
                      label: 'Goal Planner'),
                  NavigationDestination(
                    icon: Icon(
                      Icons.self_improvement,
                      size: 28,
                    ),
                    label: 'Habbits',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings, size: 28),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
