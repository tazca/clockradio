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

  void _refreshClock() {
    final int startRefresh = DateTime.now().millisecond;
    if (clock.value is LedClock) {
      clock.value = LedClock.now(old: clock.value);
    } else if (clock.value is SolarClock) {
      clock.value = SolarClock.now(old: clock.value);
    } else {
      clock.value = SolarClock.now(old: clock.value);
    }

    if (clock.value.hours == clock.value.alarmH &&
        clock.value.minutes == clock.value.alarmM) {
      radio.play();
    }

    final int secs = DateTime.now().second;
    Timer(Duration(seconds: 60 - secs), _refreshClock);
    final int refreshTime = (DateTime.now().millisecond - startRefresh < 0)
        ? DateTime.now().millisecond + 1000 - startRefresh
        : DateTime.now().millisecond - startRefresh;
    print(
        '${clock.value.hours}.${clock.value.minutes}: Finished refreshing ${clock.value} in $refreshTime ms');
  }

  @override
  Widget build(BuildContext context) {
    _refreshClock();
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
