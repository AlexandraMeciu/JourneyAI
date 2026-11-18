import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/database/habit_db.dart';
import 'package:journal_app/utilities/data_saved.dart';
import 'package:journal_app/widgets/habit_tile.dart';
import 'package:journal_app/widgets/month_summary.dart';
import 'package:journal_app/widgets/my_alert_box.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  HabitDatabase db = HabitDatabase();
  var _newHabitNameController = TextEditingController();

  final _myBox = Hive.box('dataBox');

  @override
  void initState() {
    final curentList = _myBox.get("CURRENT_HABIT_LIST");
    if (curentList == null || (curentList is List && curentList.isEmpty)) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateDatbase();
    DataSaved().loadDate();

    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatbase();
  }

  void createNewHabit() async {
    showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return MyAlertBox(
              controller: _newHabitNameController,
              hintText: 'Enter habit name...',
              onSave: saveNewHabit,
              onCancel: cancelDialogBox);
        });
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatbase();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatbase();
  }

  void openHabitSettings(int index) {
    _newHabitNameController =
        TextEditingController(text: db.todaysHabitList[index][0]);
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitNameController,
            hintText: db.todaysHabitList[index][0],
            onSave: () => saveExistingHabit(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatbase();
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        /* floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewHabit();
          },
          child: const Icon(Icons.add),
        ),*/
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const Icon(
            Icons.self_improvement,
            size: 30,
          ),
          titleSpacing: 6,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Habit Tracker',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: createNewHabit,
                icon: Icon(Icons.add),
                iconSize: 40,
                color: (db.todaysHabitList.length >= 3)
                    ? Colors.grey
                    : Colors.white,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE"),
            ),
            Expanded(
              child: db.todaysHabitList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: db.todaysHabitList.length,
                      itemBuilder: (context, index) {
                        return HabitTile(
                          habitName: db.todaysHabitList[index][0],
                          habitCompleted: db.todaysHabitList[index][1],
                          onChanged: (value) => checkBoxTapped(value, index),
                          settingsTapped: (context) => openHabitSettings(index),
                          deleteTapped: (context) => deleteHabit(index),
                        );
                      },
                    )
                  : Center(
                      child: const Column(
                        children: [],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
