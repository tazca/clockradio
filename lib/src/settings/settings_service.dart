import 'package:shared_preferences/shared_preferences.dart';

import '../clock/clock_controller.dart' show ClockFace;

/// A service that stores and retrieves user settings.
class SettingsService {

  Future<String> radioStation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? path = prefs.getString('radioStation');
    return path ?? "assets/sounds/ping.mp3";
  }

  Future<void> updateRadioStation(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('radioStation', path);
  }

  Future<List<String>> radioStations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? paths = prefs.getStringList('radioStations');
    if (paths == null) {
      addRadioStation("assets/sounds/ping.mp3");
      addRadioStation("https://radio.plaza.one/opus");
      addRadioStation(
          "https://yleradiolive.akamaized.net/hls/live/2027718/in-YleTampere/256/variant.m3u8");
      return [
        "assets/sounds/ping.mp3",
        "https://radio.plaza.one/opus",
        "https://yleradiolive.akamaized.net/hls/live/2027718/in-YleTampere/256/variant.m3u8",
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
        return ClockFace.solar;
    }
  }

  Future<void> updateClockFace(ClockFace face) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('clockFace', face.name);
  }

  Future<int?> alarmH() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('alarmH');
  }

  Future<void> updateAlarmH(int? alarmH) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (alarmH == null) {
      await prefs.remove('alarmH');
    } else {
      await prefs.setInt('alarmH', alarmH);
    }
  }

  Future<int?> alarmM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('alarmM');
  }

  Future<void> updateAlarmM(int? alarmM) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (alarmM == null) {
      await prefs.remove('alarmM');
    } else {
      await prefs.setInt('alarmM', alarmM);
    }
  }
}
