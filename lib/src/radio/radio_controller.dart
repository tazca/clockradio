import 'dart:async' show Timer;

import '/src/settings/settings_controller.dart';

import 'radio_service.dart';

class RadioController {
  RadioController(this._radioService, this._settingsController);

  final RadioService _radioService;
  final SettingsController _settingsController;

  Timer? initiateFailsafe;

  factory RadioController.create(SettingsController settingsController) {
    return RadioController(RadioService.create(), settingsController);
  }

  void play() {
    if (isPlaying()) {
      stop();
    }
    _radioService.selectStream(_settingsController.radioStation);
    _radioService.play();
    initiateFailsafe =
        Timer(const Duration(milliseconds: 5000), failsafeStream);
  }

  void stop() {
    _radioService.stop();
    initiateFailsafe?.cancel();
  }

  void toggle() {
    if (isPlaying()) {
      stop();
    } else {
      play();
    }
  }

  bool isPlaying() {
    return _radioService.isPlaying();
  }

  void failsafeStream() {
    if (isPlaying() == false) {
      _radioService.selectStream(SettingsController.fallbackStation);
      _radioService.play();
    }
  }
}
