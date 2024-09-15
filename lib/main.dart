import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/radio/radio_controller.dart';
import 'src/clock/clock_controller.dart';

void main() async {
  final settings = SettingsController.create();
  await settings.loadSettings();

  MediaKit.ensureInitialized();
  final radio = RadioController.create(settings);

  final clock = ClockController.create(
    radio.play,
    settings,
  );
  clock.startClock();

  final app = ClockRadio(
    clock: clock,
    radio: radio,
    settings: settings,
  );

  runApp(app);
}
