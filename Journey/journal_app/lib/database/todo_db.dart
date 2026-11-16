import 'package:hive/hive.dart';
import 'package:journal_app/database/data.dart';

final _toDoBox = Hive.box('dataBox');

class ToDoDataBase {
  List<ToDoListClass> toDoClass = [];

  int percent = 0;

  void toDoPercentage(int index) {
    int countPercentage = 0;
    for (int i = 0; i < toDoClass[index].todos.length; i++) {
      if (toDoClass[index].todos[i].isCompleted == true) {
        countPercentage++;
      }
    }
    toDoClass[index].percent = countPercentage;
    _toDoBox.put("TODO_CLASS", toDoClass);

    _toDoBox.put("TODO_PERCENT", countPercentage);
  }

  void loadToDoData() {
    toDoClass =
        (_toDoBox.get("TODO_CLASS") as List<dynamic>).cast<ToDoListClass>();

    percent = _toDoBox.get("TODO_PERCENT") ?? 0;
  }

  void updateToDoDatabase(int index) {
    _toDoBox.put("TODO_CLASS", toDoClass);
    toDoPercentage(index);
    percent = _toDoBox.get("TODO_PERCENT");
  }

  void eraseList(int index) {
    toDoClass.clear();
    updateToDoDatabase(index);
  }
}
