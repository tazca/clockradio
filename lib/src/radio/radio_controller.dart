import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_libs_audio/media_kit_libs_audio.dart';

import 'radio_service.dart';

class RadioController with ChangeNotifier {
  RadioController(this._radioService);

  // Make SettingsService a private variable so it is not used directly.
  final RadioService _radioService;

  void muzak() {
    _radioService.selectStream('https://radio.plaza.one/opus');
    _radioService.play();
  }
  void suomi() {
    _radioService.selectStream('https://yleradiolive.akamaized.net/hls/live/2027718/in-YleTampere/256/variant.m3u8');
    _radioService.play();
  }
  void stop() {
    _radioService.stop();
  }

  bool isPlaying() {
    return _radioService.isPlaying();
  }
}