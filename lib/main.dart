import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_libs_audio/media_kit_libs_audio.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/radio/radio_controller.dart';
import 'src/radio/radio_service.dart';

void main() async {
  try {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  MediaKit.ensureInitialized();
  final radioController = RadioController(RadioService.create());
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(ClockRadio(
    radioController: radioController,
    settingsController: settingsController,
  ));

  radioController.dispose();
  } catch (e) {
    print('error: $e');
  }
}
