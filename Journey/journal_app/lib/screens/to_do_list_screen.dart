import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:journal_app/database/data.dart";
import "package:journal_app/database/todo_db.dart";
import "package:journal_app/database/todo_list_db.dart";
import "package:journal_app/datetime/date_time.dart";
import "package:journal_app/revenuecat/constant.dart";
import "package:journal_app/revenuecat/purchase_api.dart";
import "package:journal_app/screens/to_do_screen.dart";
import "package:journal_app/utilities/data_saved.dart";
import "package:journal_app/widgets/my_alert_box.dart";
import "package:journal_app/widgets/todo_list_tile.dart";
import "package:journal_app/widgets/ultra_background.dart";

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  // ignore: non_constant_identifier_names
  ToDoListDataBase db_ToDo = ToDoListDataBase();
  ToDoDataBase db_dataToDo = ToDoDataBase();
  final _myboxToDo = Hive.box('dataBox');
  var _newToDoClassNameController = TextEditingController();
  @override
  void initState() {
    if (_myboxToDo.get("TODO_CLASS") != null) {
      db_ToDo.loadDataToList();
      db_dataToDo.loadToDoData();
    }

    db_ToDo.updateToDoListDataBase();

    DataSaved().loadDate();

    super.initState();
  }

  Future<void> createNewToList() async {
    if (!isPremium && db_ToDo.toDoListClass.length >= 2) {
      PurchaseApi.showPurchasePanel(context);
      checkPremium();
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newToDoClassNameController,
            hintText: "Enter new Objective",
            onSave: saveNewToDoList,
            onCancel: cancelDialogBox,
          );
        });
  }

  void saveNewToDoList() {
    final newToDoList = ToDoListClass(
        name: _newToDoClassNameController.text, todos: [], percent: 0);
    setState(() {
      db_ToDo.toDoListClass.add(newToDoList);
    });
    _newToDoClassNameController.clear();
    Navigator.of(context).pop();
    db_ToDo.updateToDoListDataBase();
  }

  void cancelDialogBox() {
    _newToDoClassNameController.clear();
    Navigator.of(context).pop();
  }

  void saveExistingToDoName(int index) {
    setState(() {
      db_ToDo.toDoListClass[index].name = _newToDoClassNameController.text;
    });
    _newToDoClassNameController.clear();
    Navigator.pop(context);
    db_ToDo.updateToDoListDataBase();
  }

  void openToDoClassSettings(int index) {
    _newToDoClassNameController =
        TextEditingController(text: db_ToDo.toDoListClass[index].name);
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newToDoClassNameController,
            hintText: db_ToDo.toDoListClass[index].name,
            onSave: () => saveExistingToDoName(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  void deleteToDoClass(int index) {
    setState(() {
      db_ToDo.toDoListClass.removeAt(index);
    });
    db_ToDo.updateToDoListDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const Icon(
            Icons.developer_board,
            size: 30,
          ),
          titleSpacing: 10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Goal Planner",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: createNewToList,
                icon: Icon(Icons.add),
                iconSize: 40,
                color: (db_ToDo.toDoListClass.length >= 2 && !isPremium)
                    ? Colors.grey
                    : Colors.white,
              )
            ],
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              db_ToDo.toDoListClass.isNotEmpty
                  ? ListView.builder(
                      itemCount: db_ToDo.toDoListClass.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ToDoListTile(
                          toDoListName: db_ToDo.toDoListClass[index].name,
                          settingsTapped: (value) =>
                              openToDoClassSettings(index),
                          deleteTapped: (value) => deleteToDoClass(index),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ToDoScreen(todoKey: index)),
                            ).then((_) {
                              setState(() {
                                db_ToDo.loadDataToList();
                                db_dataToDo.loadToDoData();
                              });
                            });
                          },
                          percent: (index < db_dataToDo.toDoClass.length)
                              ? db_dataToDo.toDoClass[index].percent /
                                  (db_dataToDo.toDoClass[index].todos.length
                                              .toDouble() ==
                                          0
                                      ? 1
                                      : db_dataToDo
                                          .toDoClass[index].todos.length
                                          .toDouble())
                              : 0.0,
                        );
                      })
                  : const Column(
                      children: [],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
