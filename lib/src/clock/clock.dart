import 'package:flutter/material.dart';

@immutable
class Clock {
  const Clock(
    this.time,
    this.alarm,
    this.tzOffset,
    this.nthDayOfYear,
    this.userLatitude,
    this.userLongitude,
  );
  final TimeOfDay time;
  final TimeOfDay? alarm;

  final Duration tzOffset;
  final int nthDayOfYear;

  final double userLatitude;
  final double userLongitude;

  int get hours => time.hour;
  int get minutes => time.minute;
  int? get alarmH => alarm?.hour;
  int? get alarmM => alarm?.minute;

  factory Clock.now({
    Clock? old,
    double? userLatitude,
    double? userLongitude,
    TimeOfDay? alarm,
  }) {
    final daysSinceJan1 = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1, 0, 0))
        .inDays;

    return Clock(
      TimeOfDay.now(),
      alarm ?? old?.alarm, // specific parameter > old delegate > null value
      DateTime.now().timeZoneOffset,
      daysSinceJan1 + 1,
      userLatitude ?? old?.userLatitude ?? 0.0,
      userLongitude ?? old?.userLongitude ?? 0.0,
    );
  }

  bool get isAlarmRinging {
    return time == alarm;
  }
}
