import 'package:flutter/material.dart';
import 'dart:async';

import '../settings/settings_view.dart';
import '../radio/radio_controller.dart';

import 'clock.dart';
import 'ledclock.dart';
import 'solarclock.dart';

class ClockView extends StatelessWidget {
  const ClockView({
    super.key,
    required this.clock,
    required this.radio,
  });

  static const routeName = '/';

  final ValueNotifier<Clock> clock;
  final RadioController radio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ListenableBuilder(
            listenable: clock,
            builder: (BuildContext context, Widget? child) {
              return GestureDetector(
                child: clock.value.build(context),
                onLongPress: () {
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
                },
                onTap: () {
                  if (radio.isPlaying()) {
                    radio.stop();
                  } else {
                    radio.play();
                  }
                },
              );
            }),
      ),
    );
  } // Widget

}
