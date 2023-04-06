import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeOfDay(TimeOfDay timeOfDay) {
  String period = timeOfDay.hour >= 12 ? 'PM' : 'AM';
  int hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
  String minute = timeOfDay.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}

TimeOfDay stringToTimeOfDay(String timeString) {
  final format = DateFormat.jm();
  final dateTime = format.parse(timeString);
  return TimeOfDay.fromDateTime(dateTime);
}

String getDayOfWeek(DateTime date) {
  final DateFormat formatter = DateFormat('EEEE');
  final String formatted = formatter.format(date);
  return formatted;
}

