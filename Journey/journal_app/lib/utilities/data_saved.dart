import 'package:shared_preferences/shared_preferences.dart';

bool morningSwitchValue = false;
bool eveningSwitchValue = false;

class DataSaved {
  Future<void> loadDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? morningNotes = prefs.getBool('morningNotification');
    final bool? eveningNotes = prefs.getBool('eveningNotification');

    if (morningNotes != null) {
      morningSwitchValue = morningNotes;
    }

    if (eveningNotes != null) {
      eveningSwitchValue = eveningNotes;
    }
  }

  bool morningValue() {
    loadDate();

    return morningSwitchValue;
  }

  bool eveningValue() {
    loadDate();

    return eveningSwitchValue;
  }
}
