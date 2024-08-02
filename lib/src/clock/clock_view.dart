import 'package:flutter/material.dart';
import 'dart:async';

import '../settings/settings_view.dart';
import '../radio/radio_controller.dart';

class ClockView extends StatelessWidget {
  const ClockView({
    super.key,
    required this.clock,
    required this.radio,
  });

  static const routeName = '/';

  final StatelessWidget clock;
  final RadioController radio;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: GestureDetector(
          child: clock.build(context),
          onLongPress: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
          onTap: () {
            radio.toggle();
          },
        ),
      ),
    );
  } // Widget
}
