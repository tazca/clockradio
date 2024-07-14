import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

import 'clock.dart';

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
    clock.value = Clock.now(); 
    final int secs = DateTime.now().second;
    Timer(Duration(seconds: 60 - secs), _refreshClock);
    final int refreshTime = 
      (DateTime.now().millisecond - startRefresh < 0) 
        ? DateTime.now().millisecond + 1000 - startRefresh
        : DateTime.now().millisecond - startRefresh;
    print('Finish refresh in $refreshTime ms at $clockHeight dpi');
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
            return Stack(
              children: <Widget>[
                for (String led in clock.value.activeLeds) 
                  SvgPicture.asset('assets/images/led_segments/$led.svg', height: clockHeight),
              ],
            );
          }
        ),
      ),
    );
  } // Widget
}
