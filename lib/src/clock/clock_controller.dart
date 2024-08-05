import 'package:flutter/material.dart';
import 'dart:async';

import '/src/settings/settings_controller.dart';

import 'clock.dart';
import 'ledclock.dart';
import 'solarclock.dart';

class ClockController with ChangeNotifier {
  ClockController(
    this._alarmCallback,
    this._clock,
    this._settingsController,
    this._userLatitude,
    this._userLongitude,
  );

  Function _alarmCallback;
  Clock _clock;
  final SettingsController _settingsController;

  final double _userLatitude;
  final double _userLongitude;

  factory ClockController.create(
    Function alarmCallback,
    SettingsController settingsController,
    double userLatitude,
    double userLongitude,
  ) {
    return ClockController(
      alarmCallback,
      Clock.now(userLatitude: userLatitude, userLongitude: userLongitude),
      settingsController,
      userLatitude,
      userLongitude,
    );
  }

  int get mins => _clock.minutes;
  int get hrs => _clock.hours;
  int? get aH => _clock.alarmH;
  int? get aM => _clock.alarmM;

  Duration get tz => _clock.tzOffset;
  int get nthDay => _clock.nthDayOfYear;

  double get userLat => _userLatitude;
  double get userLong => _userLongitude;

  StatelessWidget buildClock() {
    switch (_settingsController.clockFace) {
      case ClockFace.led:
        return LedClock(clock: this);
      case ClockFace.solar:
        return SolarClock(clock: this);
    }
  }

  void startClock() {
    _clock = Clock.now(old: _clock);

    if (_clock.isAlarmRinging) {
      _alarmCallback();
    }

    Timer(Duration(seconds: 60 - DateTime.now().second), startClock);
    notifyListeners();
  }

  void setAlarm(int? alarmH, int? alarmM) {
    _clock = Clock.now(old: _clock, alarmH: alarmH, alarmM: alarmM);
  }
}

enum ClockFace { led, solar }
