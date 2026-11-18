import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/database/data.dart';
import 'package:journal_app/database/priorities_db.dart';
import 'package:journal_app/utilities/app_colors.dart';
import 'package:journal_app/widgets/my_alert_box.dart';
import 'package:journal_app/widgets/todo_tile.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class PriorityScreen extends StatefulWidget {
  const PriorityScreen({super.key});

  @override
  State<PriorityScreen> createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> {
  PriorityDataBase db_Priority = PriorityDataBase();
  var _newPriorityController = TextEditingController();
  final priorityBox = Hive.box('dataBox');

  @override
  void initState() {
    if (priorityBox.get("PRIORITY_CLASS") != null) {
      db_Priority.loadPriorityData();
    } else {
      db_Priority.createData();
    }

    // TODO: implement initState
    super.initState();
  }

  Future<void> createNewPriority() async {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newPriorityController,
            hintText: "Enter new priority",
            onSave: saveNewPriority,
            onCancel: cancelDialogBox,
          );
        });
  }

  void saveNewPriority() {
    setState(() {
      db_Priority.todayPrioritiesList.add(
          ToDo(objective: _newPriorityController.text, isCompleted: false));
    });
    _newPriorityController.clear();
    Navigator.of(context).pop();
    db_Priority.updatePriorityData();
  }

  void cancelDialogBox() {
    _newPriorityController.clear();
    Navigator.of(context).pop();
  }

  void checkBox(bool? value, int index) {
    setState(() {
      db_Priority.todayPrioritiesList[index].isCompleted = value;
    });
    db_Priority.updatePriorityData();
  }

  void deletePriority(int index) {
    setState(() {
      db_Priority.todayPrioritiesList.removeAt(index);
    });
    db_Priority.updatePriorityData();
  }

  void openSettings(int index) {
    _newPriorityController = TextEditingController(
        text: db_Priority.todayPrioritiesList[index].objective);
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newPriorityController,
            hintText: db_Priority.todayPrioritiesList[index].objective,
            onSave: () => updatePriority(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  void updatePriority(int index) {
    setState(() {
      db_Priority.todayPrioritiesList[index].objective =
          _newPriorityController.text;
    });
    _newPriorityController.clear();
    Navigator.pop(context);
    db_Priority.updatePriorityData();
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Icon(
            Icons.note_alt_outlined,
            size: 30,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "24h Priorities",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: db_Priority.percent /
                      (db_Priority.todayPrioritiesList.length.toDouble() == 0
                          ? 1
                          : db_Priority.todayPrioritiesList.length.toDouble()),
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.primaryColor,
                  ),
                  strokeWidth: 5,
                ),
              ),
              Text(
                '${db_Priority.percent}/${db_Priority.todayPrioritiesList.length}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewPriority();
          },
          child: Icon(
            Icons.add,
            color: (db_Priority.todayPrioritiesList.length >= 5)
                ? Colors.grey
                : Colors.white,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(bottom: 80),
          children: [
            SizedBox(
              height: 5,
            ),
            db_Priority.todayPrioritiesList.isNotEmpty
                ? ListView.builder(
                    itemCount: db_Priority.todayPrioritiesList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        todoName:
                            db_Priority.todayPrioritiesList[index].objective,
                        todoComplete:
                            db_Priority.todayPrioritiesList[index].isCompleted,
                        onChanged: (value) => checkBox(value, index),
                        settingsTapped: (value) => openSettings(index),
                        deleteTapped: (value) => deletePriority(index),
                      );
                    })
                : Column(
                    children: [],
                  ),
          ],
        ),
      ),
    );
  }
}
