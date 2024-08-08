import 'package:flutter/material.dart';

import '/src/clock/clock_controller.dart' show ClockFace;

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  // Use getters & private variables so theyare not updated directly without
  // also persisting the changes with the SettingsService.
  late String _radioStation;
  late List<String> _radioStations;
  late ClockFace _clockFace;
  
  late TimeOfDay? _alarm;

  late double _latitude;
  late double _longitude;

  late bool _oled;
  late bool _intro;

  // Allow Widgets to read the user's preferred ThemeMode.
  String get radioStation => _radioStation;
  List<String> get radioStations => _radioStations;
  ClockFace get clockFace => _clockFace;
  TimeOfDay? get alarm => _alarm;
  double get latitude => _latitude; 
  double get longitude => _longitude; 
  bool get oled => _oled; 
  bool get intro => _intro; 

  factory SettingsController.create() {
    return SettingsController(SettingsService());
  }

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _radioStation = await _settingsService.radioStation();
    _radioStations = await _settingsService.radioStations();
    _clockFace = await _settingsService.clockFace();
    final int? alarmH = await _settingsService.alarmH();
    final int? alarmM = await _settingsService.alarmM();
    _alarm = alarmH != null && alarmM != null ? TimeOfDay(hour: alarmH, minute: alarmM) : null;
    _latitude = await _settingsService.latitude();
    _longitude = await _settingsService.longitude();
    _oled = await _settingsService.oled();
    _intro = await _settingsService.intro();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> updateRadioStation(String? newRadioStation) async {
    if (newRadioStation == null) return;
    if (newRadioStation == _radioStation) return;

    _radioStation = newRadioStation;
    notifyListeners();
    await _settingsService.updateRadioStation(newRadioStation);
  }

  Future<void> addRadioStation(String? newRadioStation) async {
    if (newRadioStation == null) return;
    if (newRadioStation == _radioStation) return;

    _radioStation = newRadioStation;
    await _settingsService.addRadioStation(newRadioStation);
    _radioStations = await _settingsService.radioStations();
    notifyListeners();
  }

  Future<void> updateClockFace(ClockFace? newClockFace) async {
    if (newClockFace == null) return;
    if (newClockFace == _clockFace) return;

    _clockFace = newClockFace;
    notifyListeners();
    await _settingsService.updateClockFace(newClockFace);
  }

  Future<void> updateAlarm(TimeOfDay? newAlarm) async {
    if (newAlarm == _alarm) return;
    _alarm = newAlarm;
    notifyListeners();
    await _settingsService.updateAlarmH(newAlarm?.hour);
    await _settingsService.updateAlarmM(newAlarm?.minute);
  }

  Future<void> updateLatitude(double? newLatitude) async {
    if (newLatitude == null) return;
    if (newLatitude == _latitude) return;

    _latitude = newLatitude;
    notifyListeners();
    await _settingsService.updateLatitude(newLatitude);
  }
  Future<void> updateLongitude(double? newLongitude) async {
    if (newLongitude == null) return;
    if (newLongitude == _longitude) return;

    _longitude = newLongitude;
    notifyListeners();
    await _settingsService.updateLongitude(newLongitude);
  }

  Future<void> updateOled(bool? newOled) async {
    if (newOled == null) return;
    if (newOled == _oled) return;

    _oled = newOled;
    notifyListeners();
    await _settingsService.updateOled(newOled);
  }

  Future<void> updateIntro(bool? newIntro) async {
    if (newIntro == null) return;
    if (newIntro == _intro) return;

    _intro = newIntro;
    notifyListeners();
    await _settingsService.updateIntro(newIntro);
  }
}
