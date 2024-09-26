import 'package:shared_preferences/shared_preferences.dart';

import '/src/clock/clock_controller.dart' show ClockFace;

/// A service that stores and retrieves user settings.
class SettingsService {
  SettingsService();

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> radioStation() async {
    final String? path = prefs.getString('radioStation');
    return path;
  }

  Future<void> updateRadioStation(String path) async {
    await prefs.setString('radioStation', path);
  }

  Future<List<String>?> radioStations() async {
    final List<String>? paths = prefs.getStringList('radioStations');
    return paths;
  }

  Future<void> addRadioStation(String path) async {
    final List<String>? paths = prefs.getStringList('radioStations');
    if (paths == null) {
      await prefs.setStringList('radioStations', [path]);
    } else {
      if (paths.contains(path)) {
        return;
      } else {
        paths.add(path);
        await prefs.setStringList('radioStations', paths);
      }
    }
  }

  Future<void> removeRadioStation(String path) async {
    final List<String>? paths = prefs.getStringList('radioStations');
    if (paths == null) {
      return;
    } else {
      paths.removeWhere((element) => element == path);
      if (paths.isEmpty) {
        await prefs.remove('radioStations');
        await prefs.remove('radioStation');
        return;
      } else {
        await prefs.setStringList('radioStations', paths);
        return;
      }
    }
  }

  Future<ClockFace> clockFace() async {
    final String? face = prefs.getString('clockFace');
    switch (face) {
      case 'led':
        return ClockFace.led;
      case 'solar':
        return ClockFace.solar;
      default:
        return ClockFace.led;
    }
  }

  Future<void> updateClockFace(ClockFace face) async {
    await prefs.setString('clockFace', face.name);
  }

  Future<int> alarmH() async {
    return prefs.getInt('alarmH') ?? 0;
  }

  Future<void> updateAlarmH(int alarmH) async {
    await prefs.setInt('alarmH', alarmH);
  }

  Future<int> alarmM() async {
    return prefs.getInt('alarmM') ?? 0;
  }

  Future<void> updateAlarmM(int alarmM) async {
    await prefs.setInt('alarmM', alarmM);
  }

  Future<bool> alarmSet() async {
    return prefs.getBool('alarmSet') ?? false;
  }

  Future<void> updateAlarmSet(bool alarmSet) async {
    await prefs.setBool('alarmSet', alarmSet);
  }

  Future<double> latitude() async {
    return prefs.getDouble('latitude') ?? 0.0;
  }

  Future<void> updateLatitude(double latitude) async {
    await prefs.setDouble('latitude', latitude);
  }

  Future<double> longitude() async {
    return prefs.getDouble('longitude') ?? 0.0;
  }

  Future<void> updateLongitude(double longitude) async {
    await prefs.setDouble('longitude', longitude);
  }

  Future<bool> oled() async {
    return prefs.getBool('oled') ?? false;
  }

  Future<void> updateOled(bool oled) async {
    await prefs.setBool('oled', oled);
  }

  Future<bool> intro() async {
    return prefs.getBool('intro') ?? true;
  }

  Future<void> updateIntro(bool intro) async {
    await prefs.setBool('intro', intro);
  }


  Future<double?> uiScale() async {
    return prefs.getDouble('uiScale');
  }

  Future<void> updateUIScale(double newUIScale) async {
    await prefs.setDouble('uiScale', newUIScale);
  }
}
