import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class Data {
  Data({required this.pass, required this.passHint});
  @HiveField(0)
  late String pass;

  @HiveField(1)
  late String passHint;
}

@HiveType(typeId: 1)
class ToDo {
  ToDo({required this.objective, required this.isCompleted});
  @HiveField(0)
  late String objective;

  @HiveField(1)
  late bool? isCompleted;
}

@HiveType(typeId: 2)
class ToDoListClass {
  ToDoListClass(
      {required this.name, required this.todos, required this.percent});
  @HiveField(0)
  late String name;

  @HiveField(1)
  List<ToDo> todos;
  @HiveField(2)
  int percent;
}
