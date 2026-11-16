import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journal_app/database/data.dart';
import 'package:journal_app/database/todo_db.dart';
import 'package:journal_app/utilities/app_colors.dart';
import 'package:journal_app/widgets/my_alert_box.dart';
import 'package:journal_app/widgets/ultra_background.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key, required this.todoKey});
  final int todoKey;

  int todoKeyIndex() {
    return todoKey;
  }

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  // ignore: non_constant_identifier_names
  ToDoDataBase db_ToDo = ToDoDataBase();

  int indexToDoList = 0;
  double toDoNumber = 1;
  var _newToDoNameController = TextEditingController();

  final _myboxToDo = Hive.box('dataBox');
  @override
  void initState() {
    indexToDoList = widget.todoKey;

    if (_myboxToDo.get("TODO_CLASS") != null) {
      db_ToDo.loadToDoData();
    }

    if (db_ToDo.toDoClass[indexToDoList].todos.length.toDouble() != 0) {
      toDoNumber = db_ToDo.toDoClass[indexToDoList].todos.length.toDouble();
    }
    db_ToDo.updateToDoDatabase(indexToDoList);

    super.initState();
  }

  void checkBox(bool? value, int index) {
    setState(() {
      db_ToDo.toDoClass[indexToDoList].todos[index].isCompleted = value;
    });
    db_ToDo.updateToDoDatabase(indexToDoList);
  }

  void createNewToDo() {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newToDoNameController,
            hintText: 'Enter new Objective',
            onSave: saveNewToDo,
            onCancel: cancelDialogBox,
          );
        });
  }

  void saveNewToDo() {
    setState(() {
      db_ToDo.toDoClass[indexToDoList].todos.add(
          ToDo(objective: _newToDoNameController.text, isCompleted: false));
    });
    _newToDoNameController.clear();
    Navigator.of(context).pop();
    db_ToDo.updateToDoDatabase(indexToDoList);
  }

  void cancelDialogBox() {
    _newToDoNameController.clear();
    Navigator.of(context).pop();
  }

  void saveExistingToDo(int index) {
    setState(() {
      db_ToDo.toDoClass[indexToDoList].todos[index].objective =
          _newToDoNameController.text;
    });
    _newToDoNameController.clear();
    Navigator.pop(context);
    db_ToDo.updateToDoDatabase(indexToDoList);
  }

  void openToDoSettings(int index) {
    _newToDoNameController = TextEditingController(
        text: db_ToDo.toDoClass[indexToDoList].todos[index].objective);
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newToDoNameController,
            hintText: db_ToDo.toDoClass[indexToDoList].todos[index].objective,
            onSave: () => saveExistingToDo(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  void deleteToDo(int index) {
    setState(() {
      db_ToDo.toDoClass[indexToDoList].todos.removeAt(index);
    });
    db_ToDo.updateToDoDatabase(indexToDoList);
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const Icon(
            Icons.developer_board,
            size: 32,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  db_ToDo.toDoClass[indexToDoList].name,
                  style: const TextStyle(fontSize: 22),
                  softWrap: false,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              /* const SizedBox(
                height: 10,
              ),*/
              /*    SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: db_ToDo.percent /
                      (db_ToDo.toDoClass[indexToDoList].todos.length
                                  .toDouble() ==
                              0
                          ? 1
                          : db_ToDo.toDoClass[indexToDoList].todos.length
                              .toDouble()),
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.primaryColor,
                  ),
                  strokeWidth: 5,
                ),
              ),*/
              Text(
                '${db_ToDo.percent}/${db_ToDo.toDoClass[indexToDoList].todos.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewToDo();
          },
          child: const Icon(Icons.add),
        ),
        body: db_ToDo.toDoClass[indexToDoList].todos.isEmpty
            ? SizedBox.shrink()
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 80, top: 8),
                itemCount: db_ToDo.toDoClass[indexToDoList].todos.length,
                itemBuilder: (context, index) {
                  final todo = db_ToDo.toDoClass[indexToDoList].todos[index];
                  final isLast = index ==
                      db_ToDo.toDoClass[indexToDoList].todos.length - 1;
                  final isCompleted = todo.isCompleted ?? false;
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () => checkBox(!isCompleted, index),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted
                                          ? AppColors.primaryColor
                                          : Colors.transparent,
                                      border: Border.all(
                                          color: isCompleted
                                              ? AppColors.primaryColor
                                              : Colors.grey,
                                          width: 2.5)),
                                  child: isCompleted
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                    child: Container(
                                  width: 2.5,
                                  color: isCompleted
                                      ? AppColors.primaryColor
                                      : Colors.grey.withAlpha(175),
                                ))
                            ],
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(right: 16, bottom: 16),
                          child: Card(
                            color: Colors.white.withAlpha(75),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: isCompleted
                                        ? AppColors.primaryColor.withAlpha(175)
                                        : Colors.grey.withAlpha(125))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        todo.objective,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          decorationColor: Colors.grey,
                                        ),
                                      )),
                                      IconButton(
                                        onPressed: () =>
                                            openToDoSettings(index),
                                        icon: Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () => deleteToDo(index),
                                        icon: Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Step ${index + 1} of'
                                        '${db_ToDo.toDoClass[indexToDoList].todos.length}',
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      /*  ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: (index + 1) /
                                              db_ToDo.toDoClass[indexToDoList]
                                                  .todos.length,
                                          minHeight: 4,
                                          backgroundColor:
                                              Colors.grey.withAlpha(90),
                                          valueColor: AlwaysStoppedAnimation(
                                              isCompleted
                                                  ? AppColors.primaryColor
                                                  : Colors.grey),
                                        ),
                                      )*/
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  );
                },
              ),

        /*ListView(
          padding: EdgeInsets.only(bottom: 80),
          children: [
            const SizedBox(
              height: 5,
            ),
            db_ToDo.toDoClass[indexToDoList].todos.isNotEmpty
                ? ListView.builder(
                    itemCount: db_ToDo.toDoClass[indexToDoList].todos.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        todoName: db_ToDo
                            .toDoClass[indexToDoList].todos[index].objective,
                        todoComplete: db_ToDo
                            .toDoClass[indexToDoList].todos[index].isCompleted,
                        onChanged: (value) => checkBox(value, index),
                        settingsTapped: (value) => openToDoSettings(index),
                        deleteTapped: (value) => deleteToDo(index),
                      );
                    })
                : const Column(
                    children: [],
                  ),
          ],
        ),*/
      ),
    );
  }
}
