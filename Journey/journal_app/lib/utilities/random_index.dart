import 'dart:math';
import 'package:hive/hive.dart';

final _myBox = Hive.box('dataBox');
List usedIndex = [];
int generateUniqueRandomIndex(int maxIndex) {
  _myBox.get("INDEX_LIST") != null
      ? usedIndex = _myBox.get("INDEX_LIST")
      : usedIndex = [];

  // If all possible indices have been used, reset the used indices
  if (usedIndex.length >= maxIndex) {
    usedIndex.clear();
    _myBox.put("INDEX_LIST", usedIndex);
    throw Exception('All possible indices have been used.');
  }

  // Generate a unique random index
  int randomIndex;
  do {
    randomIndex = Random().nextInt(maxIndex);
  } while (usedIndex.contains(randomIndex));

  // Add the new index to the set and save it to preferences
  usedIndex.add(randomIndex);

  _myBox.put("INDEX_LIST", usedIndex);

  return randomIndex;
}
