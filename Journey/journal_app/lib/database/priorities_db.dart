import 'package:hive/hive.dart';
import 'package:journal_app/database/data.dart';
import 'package:journal_app/datetime/date_time.dart';

final _priorityBox = Hive.box('dataBox');

class PriorityDataBase {
  List<ToDo> todayPrioritiesList = [];
  int percent = 0;

  void createData() {
    String formattedDate = nowTime.toString();

    _priorityBox.put("TODAY_DATE", formattedDate);

    updatePriorityData();
  }

  void priorityPercent() {
    int countPercent = 0;
    for (int i = 0; i < todayPrioritiesList.length; i++) {
      if (todayPrioritiesList[i].isCompleted == true) {
        countPercent++;
      }
    }
    _priorityBox.put("PRIORITY_PERCENT", countPercent);
  }

  void loadPriorityData() {
    bool check = false;
    var date = _priorityBox.get("TODAY_DATE");

    DateTime savedTime =
        DateTime.parse(date ?? DateTime.now().toIso8601String());

    check = checkIf24hPassed(savedTime);

    if (check == false) {
      todayPrioritiesList =
          (_priorityBox.get("PRIORITY_CLASS") as List<dynamic>).cast<ToDo>();

      percent = _priorityBox.get("PRIORITY_PERCENT") ?? 0;
    } else {
      eraseList();
      createData();
    }
  }

  void updatePriorityData() {
    _priorityBox.put("PRIORITY_CLASS", todayPrioritiesList);
    priorityPercent();
    percent = _priorityBox.get("PRIORITY_PERCENT");
  }

  void eraseList() {
    todayPrioritiesList.clear();
  }

  bool checkIf24hPassed(DateTime savedTime) {
    DateTime currentTime = DateTime.now();
    bool check;

    Duration difference = currentTime.difference(savedTime);

    difference.inHours >= 24 ? check = true : check = false;

    return check;
  }
}
