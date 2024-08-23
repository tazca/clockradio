import 'package:shared_preferences/shared_preferences.dart';

import '/src/clock/clock_controller.dart' show ClockFace;

/// A service that stores and retrieves user settings.
class SettingsService {
  Future<String> radioStation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? path = prefs.getString('radioStation');
    return path ?? 'assets/sounds/ping.mp3';
  }

  Future<void> updateRadioStation(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('radioStation', path);
  }

  Future<List<String>> radioStations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? paths = prefs.getStringList('radioStations');
    if (paths == null) {
      addRadioStation('assets/sounds/ping.mp3');
      return [
        'assets/sounds/ping.mp3',
      ];
    } else {
      return paths;
    }
  }

  Future<void> addRadioStation(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

  Future<ClockFace> clockFace() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('clockFace', face.name);
  }

  Future<int> alarmH() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('alarmH') ?? 0;
  }

  Future<void> updateAlarmH(int alarmH) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarmH', alarmH);
  }

  Future<int> alarmM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('alarmM') ?? 0;
  }

  Future<void> updateAlarmM(int alarmM) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarmM', alarmM);
  }

  Future<bool> alarmSet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('alarmSet') ?? false;
  }

  Future<void> updateAlarmSet(bool alarmSet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alarmSet', alarmSet);
  }

  Future<double> latitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('latitude') ?? 0.0;
  }

  Future<void> updateLatitude(double latitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
  }

  Future<double> longitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('longitude') ?? 0.0;
  }

  Future<void> updateLongitude(double longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('longitude', longitude);
  }

  Future<bool> oled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('oled') ?? false;
  }

  Future<bool> updateOled(bool oled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('oled', oled);
  }

  Future<bool> intro() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('intro') ?? true;
  }

  Future<bool> updateIntro(bool intro) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('intro', intro);
  }
}
