import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/main.dart';
import 'package:journal_app/revenuecat/constant.dart';
import 'package:journal_app/revenuecat/feature_item.dart';
import 'package:journal_app/revenuecat/paywall_screen.dart';
import 'package:journal_app/utilities/data_saved.dart';
import 'package:journal_app/widgets/ultra_background.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TimeOfDay _selectedTimeMorning = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _selectedTimeEvening = const TimeOfDay(hour: 20, minute: 0);

  var hourM = 8;
  var minuteM = 0;
  var hourE = 20;
  var minuteE = 0;
  bool morningSwitch = DataSaved().morningValue();
  bool eveningSwitch = DataSaved().eveningValue();

  @override
  void initState() {
    super.initState();
    notificationSettings();
  }

  void notificationSettings() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        notifications = true;
        _loadSavedData();
      } /*else {
        notification = false;
      }*/
    });
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  Future<void> _loadSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? hourM = prefs.getInt('notification_morning_hour');
    final int? minuteM = prefs.getInt('notification_morning_minute');
    final int? hourE = prefs.getInt('notification_evening_hour');
    final int? minuteE = prefs.getInt('notification_evening_minute');

    if (hourM != null && minuteM != null) {
      setState(() {
        _selectedTimeMorning = TimeOfDay(hour: hourM, minute: minuteM);
      });
    }

    if (hourE != null && minuteE != null) {
      setState(() {
        _selectedTimeEvening = TimeOfDay(hour: hourE, minute: minuteE);
      });
    }
  }

  Future<void> _selectTimeMorning(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimeMorning,
    );

    if (picked != null && picked != _selectedTimeMorning) {
      setState(() {
        _selectedTimeMorning = picked;
      });
      await _scheduleMorningDailyNotification(_selectedTimeMorning);
      await _saveMorningTime(_selectedTimeMorning);
    }
  }

  Future<void> _selectTimeEvening(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimeEvening,
    );

    if (picked != null && picked != _selectedTimeEvening) {
      setState(() {
        _selectedTimeEvening = picked;
      });
      await _scheduleEveningDailyNotification(_selectedTimeEvening);
      await _saveEveningTime(_selectedTimeEvening);
    }
  }

  Future<void> _saveMorningTime(TimeOfDay time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_morning_hour', time.hour);
    await prefs.setInt('notification_morning_minute', time.minute);
  }

  Future<void> _saveEveningTime(TimeOfDay time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_evening_hour', time.hour);
    await prefs.setInt('notification_evening_minute', time.minute);
  }

  Future<void> _scheduleMorningDailyNotification(TimeOfDay time) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Good Morning!',
        body: 'Set your intention for the day to stay grounded and focused.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  Future<void> _scheduleEveningDailyNotification(TimeOfDay time) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'Good Evening!',
        body:
            'Take a moment to unwind, clear your mind, and dive into your thoughts.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> cancelNotifications(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> setMorningNotification(bool morningNotification) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('morningNotification', morningNotification);
    if (morningNotification == true) {
      _selectTimeMorning(context);
    } else {
      cancelNotifications(1);
    }
  }

  Future<void> setEveningNotification(bool eveningNotification) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('eveningNotification', eveningNotification);
    if (eveningNotification == true) {
      _selectTimeEvening(context);
    } else {
      cancelNotifications(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UltraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: const Icon(
            Icons.settings,
            size: 30,
          ),
          title: const Text(
            "Settings",
            style: TextStyle(fontSize: 32),
          ),
        ),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              if (!notifications)
                Column(
                  children: [
                    Container(
                      //    width: 400,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueGrey.withAlpha(145),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            "To get reminders, you need to go to your device's settings and turn on notifications from Odyssey.",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.blueGrey.withAlpha(145),
                                  foregroundColor: Colors.blueGrey,
                                  padding: EdgeInsetsGeometry.symmetric(
                                      vertical: 10, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(15))),
                              onPressed: () {
                                AwesomeNotifications()
                                    .isNotificationAllowed()
                                    .then((isAllowed) {
                                  if (!isAllowed) {
                                    AwesomeNotifications()
                                        .requestPermissionToSendNotifications();
                                  }
                                });
                              },
                              child: Text(
                                "Turn on notification",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              /*const SizedBox(
                height: 30,
              ),*/
              Container(
                //   width: 400,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blueGrey.withAlpha(145), width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Morning notification',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Switch(
                        inactiveTrackColor: Colors.blueGrey.withAlpha(145),
                        activeThumbColor: Colors.white,
                        value: morningSwitch,
                        onChanged: (bool value) {
                          setState(() {
                            morningSwitch = value;
                          });
                          setMorningNotification(morningSwitch);
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                //  width: 400,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blueGrey.withAlpha(145), width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Evening notification',
                      style: TextStyle(fontSize: 20),
                    ),
                    Switch(
                        inactiveTrackColor: Colors.blueGrey.withAlpha(145),
                        activeThumbColor: Colors.white,
                        value: eveningSwitch,
                        onChanged: (bool value) {
                          setState(() {
                            eveningSwitch = value;
                          });
                          setEveningNotification(eveningSwitch);
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if (!isPremium)
                Container(
                  //.        width: 400,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueGrey.withAlpha(145), width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Premium Version",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.orange[800]),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8),
                      FeatureItem("Guided Journaling."),
                      FeatureItem("Unlimited habits."),
                      FeatureItem("Unlimited priorities."),
                      FeatureItem("Unlimited goals."),
                      FeatureItem("Export your journals to PDF."),
                      Text(
                          "Try 14 day free trial. Cancel anytime, no penalties or fees."),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.withAlpha(130),
                            foregroundColor: Colors.blueGrey,
                            padding: EdgeInsetsGeometry.symmetric(
                                vertical: 10, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusGeometry.circular(15))),
                        child: Text(
                          "Try For Free",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (!isPremium) {
                            Offerings? offerings;
                            try {
                              offerings = await Purchases.getOfferings();
                            } catch (e) {
                              debugPrint('Error fetching offerings: $e');
                            }

                            if (offerings != null &&
                                offerings.current != null) {
                              await showModalBottomSheet(
                                  useRootNavigator: true,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    checkPremium();
                                    return PaywallScreen(
                                        offering: offerings!.current!);
                                  });
                            }
                            return;
                          }
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
