import 'package:hive/hive.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/utilities/guidance_list.dart';
import 'package:journal_app/utilities/random_index.dart';

final _planBox = Hive.box('dataBox');

class PlanDataBase {
  List todaysPlanList = [];
  final int maxIndex = guidance.length;

  void createData() {
    int index = generateUniqueRandomIndex(guidance.length);

    todaysPlanList.add([
      convertDateTimeToString(nowTime),
      "Ground your day with intention",
      "",
      "How are you feeling in this moment?",
      "",
      "Where your energy went today?",
      "",
      "Today's gratitude moment…",
      "",
      "Daily reflection: ${guidance[index]}",
      "",
      "Open space to pour out your thoughts freely:",
      "",
    ]);
    updatePlanDB();
  }

  void loadPlanData() {
    todaysPlanList = _planBox.get("TODAYS_INFO") ?? [];
    if (todaysPlanList.isEmpty) {
      createData();
    }
  }

  void updatePlanDB() {
    _planBox.put("TODAYS_INFO", todaysPlanList);
  }

  void eraseList() {
    todaysPlanList.clear();
    updatePlanDB();
  }
}
