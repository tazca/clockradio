import 'package:flutter/material.dart';
import 'dart:async';

import 'clock.dart';
import 'ledclock.dart';
import 'solarclock.dart';

class ClockView extends StatelessWidget {
  const ClockView({
    super.key,
    required this.clock,
    required this.clockHeight,
  });

  static const routeName = '/';

  final ValueNotifier<Clock> clock;
  final double clockHeight;

  void _refreshClock() {
    final int startRefresh = DateTime.now().millisecond;
    if (clock.value is LedClock) {
      clock.value = LedClock.now();
    } else if (clock.value is SolarClock) {
      clock.value = SolarClock.now();
    } else {
      clock.value = Clock.now();
    }
    
    final int secs = DateTime.now().second;
    Timer(Duration(seconds: clock.value.refreshEveryNSeconds - secs), _refreshClock);
    final int refreshTime = 
      (DateTime.now().millisecond - startRefresh < 0) 
        ? DateTime.now().millisecond + 1000 - startRefresh
        : DateTime.now().millisecond - startRefresh;
    print('Finish refreshing ${clock.value} in $refreshTime ms at $clockHeight dpi');
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
              onTap: () {
                if (clock.value is LedClock) {
                  clock.value = SolarClock.now();
                } else if (clock.value is SolarClock) {
                  clock.value = LedClock.now();
                } else {
                  clock.value = LedClock.now();
                }
              },
              child: clock.value.makeWidget(clockHeight),
            );
          }
        ),
      ),
    );
  } // Widget
}
