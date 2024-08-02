import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/radio/radio_controller.dart';
import 'src/clock/clock_controller.dart';

void main() async {
  final settingsController = SettingsController.create();
  await settingsController.loadSettings();

  MediaKit.ensureInitialized();
  final radioController = RadioController.create(settingsController);

  final clockController = ClockController.create(
    radioController.play,
    settingsController,
    61.5,
    23.75,
  );
  clockController.startClock();

  final app = ClockRadio(
    clockController: clockController,
    radioController: radioController,
    settingsController: settingsController,
  );

  runApp(app);
}
