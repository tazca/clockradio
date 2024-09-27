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
    this._settings,
    this._userLatitude,
    this._userLongitude,
  );

  Function _alarmCallback;
  Clock _clock;
  final SettingsController _settings;

  double _userLatitude;
  double _userLongitude;

  factory ClockController.create(
    Function alarmCallback,
    SettingsController settings,
  ) {
    return ClockController(
      alarmCallback,
      Clock.now(
        userLatitude: settings.latitude,
        userLongitude: settings.longitude,
      ),
      settings,
      settings.latitude,
      settings.longitude,
    );
  }

  TimeOfDay get time => _clock.time;
  TimeOfDay? get alarm => _clock.alarm;

  Duration get tz => _clock.tzOffset;
  int get nthDay => _clock.nthDayOfYear;

  double get userLat => _userLatitude;
  double get userLong => _userLongitude;

  bool get oledJiggle => _settings.oled;
  double get uiScale => _settings.uiScale;

  StatelessWidget buildClock() {
    switch (_settings.clockFace) {
      case ClockFace.led:
        return LedClock(clock: this);
      case ClockFace.solar:
        return SolarClock(clock: this);
    }
  }

  void startClock() {
    if(_settings.alarmSet) {
      _clock = Clock.now(old: _clock, alarm: _settings.alarm);
    } else {
      _clock = Clock.now(old: _clock);
    }

    if (_clock.isAlarmRinging) {
      _alarmCallback();
    }

    Timer(Duration(seconds: 60 - DateTime.now().second), startClock);
    notifyListeners();
  }

  void setAlarm(TimeOfDay? alarm) {
    _clock = Clock.now(old: _clock, alarm: alarm);
  }

  void setLocation(double latitude, double longitude) {
    _userLatitude = latitude;
    _userLongitude = longitude;
  }
}

enum ClockFace { led, solar }
