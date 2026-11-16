import 'package:hive/hive.dart';
import 'package:journal_app/database/data.dart';

final _toDoListBox = Hive.box('dataBox');

class ToDoListDataBase {
  List<ToDoListClass> toDoListClass = [];
  void loadDataToList() {
    toDoListClass =
        (_toDoListBox.get("TODO_CLASS") as List<dynamic>).cast<ToDoListClass>();
  }

  void updateToDoListDataBase() {
    _toDoListBox.put("TODO_CLASS", toDoListClass);
  }

  void eraseList() {
    toDoListClass.clear();
    updateToDoListDataBase();
  }
}
