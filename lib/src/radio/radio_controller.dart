import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_libs_audio/media_kit_libs_audio.dart';

import '../settings/settings_controller.dart';

import 'radio_service.dart';

class RadioController with ChangeNotifier {
  RadioController(this._radioService, this._settingsController);

  final RadioService _radioService;
  final SettingsController _settingsController;

  void play() {
    _radioService.selectStream(_settingsController.radioStation);
    _radioService.play();
  }
  void stop() {
    _radioService.stop();
  }

  bool isPlaying() {
    return _radioService.isPlaying();
  }

}