// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// // Define a method to schedule an alarm
// Future<void> scheduleAlarm(DateTime dateTime, int id) async {
//   tz.initializeTimeZones();
//   final String timeZoneName = tz.local.name;
//   final tz.TZDateTime scheduledTime =
//       tz.TZDateTime.from(dateTime, tz.getLocation(timeZoneName));

//   // Create the notification details
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'alarm_channel_id',
//     'Alarm Channel',
//     icon: 'app_icon',
//     sound: RawResourceAndroidNotificationSound('alarm_sound'),
//     largeIcon: DrawableResourceAndroidBitmap('app_icon'),
//   );
// }
