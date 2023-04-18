import 'dart:async';
import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'databse/data_helper.dart';
import 'firebase_options.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'common/themes.dart';
import 'controller/general_controller.dart';
import 'global_variables.dart';
import 'models/task_history_model.dart';
import 'prefrences/theme_prefrence.dart';
import 'views/splash_screen.dart';

bool isCurrentlyOnNoInternet = false;

late RemoteMessage? navigate;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  navigate = message;
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    icon: "app_icon",
    playSound: true,
    sound: RawResourceAndroidNotificationSound(FIREBASE_SOUND_NAME),
  );

  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  print("_firebaseMessagingBackgroundHandler");
  print(message.data);
  print("message.data");
  print(message.data);
  var res = jsonDecode(message.data['data']);
  print('RES: $res');
  print('MESSAGE.DATA["TITLE"]: ${res["title"]}');
  if (res["title"] == 'Alarm') {
    var endDate = convertStringToLocalTime(res['end_date']);
    var taskInterval = res['task_interval'];
    scheduleNotificationUntilEndDate(endDate, taskInterval);
  } else {
    await FlutterLocalNotificationsPlugin().show(
        123,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: 'data');
  }

  print("Handling a background message: ${message.data}");
}

void _handleMessage(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    icon: "app_icon",
    playSound: true,
    sound: RawResourceAndroidNotificationSound(FIREBASE_SOUND_NAME),
  );

  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  print("_handleMessage");
  print(message.data);
  print("message.data");
  print(message.data);
  var res = jsonDecode(message.data['data']);
  print('RES: $res');
  print('MESSAGE.DATA["TITLE"]: ${res["title"]}');

  if (res["title"] == 'Alarm') {
    var endDate = convertStringToLocalTime(res['end_date']);
    var taskInterval = res['task_interval'];
    scheduleNotificationUntilEndDate(endDate, taskInterval);
  } else {
    await FlutterLocalNotificationsPlugin().show(
        123,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: 'data');
  }

  print("in app open");
  print(message.data['title']);
}

void onSelectNotification(String? payload) {
  print('navigate');
}

void onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  print("onDidReceiveLocalNotification");
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  print("onDidReceiveNotificationResponse");
  print(payload);
}

Future<void> _selectNotification(RemoteMessage message) async {
  navigate = message;
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    icon: "app_icon",
    playSound: true,
    sound: RawResourceAndroidNotificationSound(FIREBASE_SOUND_NAME),
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  print("message.data");
  print(message.data);
  var res = jsonDecode(message.data['data']);
  print('RES: $res');
  print('MESSAGE.DATA["TITLE"]: ${res["title"]}');

  if (res["title"] == 'Alarm') {
    var endDate = convertStringToLocalTime(res['end_date']);
    var taskInterval = res['task_interval'];
    scheduleNotificationUntilEndDate(endDate, taskInterval);
  } else {
    await FlutterLocalNotificationsPlugin().show(
        123,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: 'data');
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  FlutterLocalNotificationsPlugin().initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
}

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(GeneralController());
  await Alarm.init(showDebugLogs: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((_handleMessage));
  FirebaseMessaging.onMessage.listen((_selectNotification));

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(FIREBASE_SOUND_NAME),
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.requestPermission(
      sound: true, badge: true, alert: true, provisional: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    connectivitySubscription.cancel();
  }

  void init() async {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        print('not connected');
        isCurrentlyOnNoInternet = true;
        //  Get.to(()=>());
      } else {
        if (isCurrentlyOnNoInternet) {
          // Navigator.pop(navigatorKey.currentState!.overlay!.context);
          isCurrentlyOnNoInternet = false;
          // toast("You're online");
        }
        print('connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Sizer(
        builder: (BuildContext context, Orientation orientation, deviceType) {
      return GetMaterialApp(
        // initialBinding: LazyController(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'LMS',
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        home: const SplashScreen(),
      );
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

Future<void> scheduleNotificationUntilEndDate(endDate, interval) async {
  interval = int.parse(interval.toString());

  print('SCHEDULENOTIFICATIONUNTILENDDATE:');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    icon: "app_icon",
    playSound: true,
    sound: RawResourceAndroidNotificationSound(FIREBASE_SOUND_NAME),
    channelDescription: 'repeating description',
  );
  NotificationDetails generalNotificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Scheduled Notification",
      "This notification will be repeated until the end date is reached",
      tz.TZDateTime.now(tz.local).add(Duration(minutes: interval)),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: "Scheduled Notification");

  Timer.periodic(Duration(minutes: interval), (timer) {
    final tz.Location detroit = tz.getLocation('Asia/Karachi');
    final tz.TZDateTime now = tz.TZDateTime.now(detroit);

    print('TZ.TZDATETIME: $now');
    print('ENDDATE: $endDate');
    if (now.isBefore(endDate)) {
      var body = {
        "title": "Alarm",
        "end_date": endDate.toString(),
        "task_interval": interval
      };
      DataHelper.sendAlarm(body);
      print('NOW.ISBEFORE:');
      print('tz.TZDateTime NOW: $now');
    } else {
      var body = {
        "title": "Alarm",
        "end_date": now.toString(),
        "task_interval": interval
      };
      DataHelper.sendAlarm(body);
      timer.cancel(); // Cancel the timer when the end date is reached
    }
  });
}
