import 'package:flutter/material.dart';

import '../clock/clock_controller.dart' show ClockFace;

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
  
  // Set & load alarm from settings for now
  late int? _alarmH;
  late int? _alarmM;

  // Allow Widgets to read the user's preferred ThemeMode.
  String get radioStation => _radioStation;
  List<String> get radioStations => _radioStations;
  ClockFace get clockFace => _clockFace;
  int? get alarmH => _alarmH; 
  int? get alarmM => _alarmM; 

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
    _alarmH = await _settingsService.alarmH();
    _alarmM = await _settingsService.alarmM();

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

  Future<void> updateAlarmH(int? newAlarmH) async {
    if (newAlarmH == _alarmH) return;
    if (newAlarmH != null && (newAlarmH < 0 || newAlarmH > 23)) return;
    _alarmH = newAlarmH;
    notifyListeners();
    await _settingsService.updateAlarmH(newAlarmH);
  }
  Future<void> updateAlarmM(int? newAlarmM) async {
    if (newAlarmM == _alarmM) return;
    if (newAlarmM != null && (newAlarmM < 0 || newAlarmM > 59)) return;

    _alarmM = newAlarmM;
    notifyListeners();
    await _settingsService.updateAlarmM(newAlarmM);
  }
}
