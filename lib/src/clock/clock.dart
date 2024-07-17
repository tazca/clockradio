import 'package:flutter/material.dart';

@immutable
class Clock {
  const Clock(this.refreshEveryNSeconds, this.hours, this.minutes);
  final int refreshEveryNSeconds;
  final int hours;
  final int minutes;

  factory Clock.now() {
    final int hrs = DateTime.now().hour;
    final int mins = DateTime.now().minute;
    return Clock(60, hrs, mins);
  }

  Widget makeWidget (double clockHeight) {
    return Text (
      "$hours : $minutes"
    );
  }
}