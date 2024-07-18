import 'package:flutter/material.dart';

@immutable
class Clock {
  const Clock(this.hours, this.minutes, this.alarmH, this.alarmM);
  final int hours;
  final int minutes;
  final int? alarmH;
  final int? alarmM;

  factory Clock.now({Clock? old, int? alarmH, int? alarmM}) {
    return Clock(
      DateTime.now().hour,
      DateTime.now().minute,
      old?.alarmH ?? alarmH,
      old?.alarmM ?? alarmM,
    );
  }

  Widget makeWidget(double clockHeight) {
    return Text("$hours : $minutes");
  }
}
