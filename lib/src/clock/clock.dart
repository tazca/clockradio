import 'package:flutter/material.dart';

@immutable
class Clock {
  const Clock(
    this.hours,
    this.minutes,
    this.alarmH,
    this.alarmM,
    this.tzOffset,
    this.nthDayOfYear,
    this.userLatitude,
    this.userLongitude,
  );
  final int hours;
  final int minutes;
  final int? alarmH;
  final int? alarmM;

  final Duration tzOffset;
  final int nthDayOfYear;

  final double userLatitude;
  final double userLongitude;

  factory Clock.now({
    Clock? old,
    double? userLatitude,
    double? userLongitude,
    int? alarmH,
    int? alarmM,
  }) {
    final daysSinceJan1 = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1, 0, 0))
        .inDays;
    
    return Clock(
      DateTime.now().hour,
      DateTime.now().minute,
      alarmH ?? old?.alarmH, // specific parameter > old delegate > null value
      alarmM ?? old?.alarmM,
      DateTime.now().timeZoneOffset,
      daysSinceJan1 + 1,
      userLatitude ?? old?.userLatitude  ?? 0.0,
      userLongitude ?? old?.userLongitude ?? 0.0,
    );
  }

  bool get isAlarmRinging {
    return alarmH == hours && alarmM == minutes;
  }
}
