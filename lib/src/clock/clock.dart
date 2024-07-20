import 'package:flutter/material.dart';

@immutable
class Clock extends StatelessWidget {
  const Clock({super.key, required this.hours, required this.minutes, this.alarmH, this.alarmM});
  final int hours;
  final int minutes;
  final int? alarmH;
  final int? alarmM;

  factory Clock.now({Clock? old, int? alarmH, int? alarmM}) {
    return Clock(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      alarmH: old?.alarmH ?? alarmH,
      alarmM: old?.alarmM ?? alarmM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text("$hours : $minutes");
  }
}

enum ClockFace {
  led,
  solar
}