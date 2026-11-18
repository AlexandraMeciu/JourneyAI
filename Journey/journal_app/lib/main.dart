import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journal_app/ai/ai_service.dart';
import 'package:journal_app/chat_managers/chat_manager.dart';
import 'package:journal_app/chat_models/chat_message.dart';
import 'package:journal_app/chat_models/chat_session.dart';
import 'package:journal_app/chat_models/journal_entry.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/database/data.dart';
import 'package:journal_app/screens/carousel_presentation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(ToDoListClassAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());
  Hive.registerAdapter(MessageRoleAdapter());
  Hive.registerAdapter(JournalEntryAdapter());

  await Hive.openBox('dataBox');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('intro_status') != null) {
    firstUse = prefs.getBool('intro_status')!;
  }

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notification',
        channelDescription: 'notification channel for basic tests',
        defaultColor: Colors.black,
        importance: NotificationImportance.High,
      ),
    ],
    debug: true,
  );

  WidgetsFlutterBinding.ensureInitialized();

  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ChatManager(AiService()), // make sure AiService is imported
        ),
        // other providers...
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The navigator key is necessary to allow to navigate through static methods
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        //colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 47, 15, 104)),
        colorScheme: const ColorScheme.dark(brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: firstUse ? PresentationScreen() : WelcomeScreen(),
    );
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}
