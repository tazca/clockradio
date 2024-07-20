import 'package:flutter/material.dart';

import '../clock/clock.dart' show ClockFace;

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  late String _radioStation;
  late ClockFace _clockFace;
  
  // Set & load alarm from settings for now
  late int? _alarmH;
  late int? _alarmM;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  String get radioStation => _radioStation;
  ClockFace get clockFace => _clockFace;
  int? get alarmH => _alarmH; 
  int? get alarmM => _alarmM; 

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _radioStation = await _settingsService.radioStation();
    _clockFace = await _settingsService.clockFace();
    _alarmH = await _settingsService.alarmH();
    _alarmM = await _settingsService.alarmM();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateRadioStation(String? newRadioStation) async {
    if (newRadioStation == null) return;
    if (newRadioStation == _radioStation) return;

    _radioStation = newRadioStation;
    notifyListeners();
    await _settingsService.updateRadioStation(newRadioStation);
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

    _alarmH = newAlarmH;
    notifyListeners();
    await _settingsService.updateAlarmH(newAlarmH);
  }
  Future<void> updateAlarmM(int? newAlarmM) async {
    if (newAlarmM == _alarmM) return;

    _alarmM = newAlarmM;
    notifyListeners();
    await _settingsService.updateAlarmM(newAlarmM);
  }
}
