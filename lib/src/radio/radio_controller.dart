import '../settings/settings_controller.dart';

import 'radio_service.dart';

class RadioController {
  RadioController(this._radioService, this._settingsController);

  final RadioService _radioService;
  final SettingsController _settingsController;

  factory RadioController.create(SettingsController settingsController) {
    return RadioController(RadioService.create(), settingsController);
  }

  void play() {
    if (isPlaying()) {
      stop();
    }
    _radioService.selectStream(_settingsController.radioStation);
    _radioService.play();
  }
  void stop() {
    _radioService.stop();
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

}