import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/clock/clock_controller.dart';

@immutable
class LedClock extends StatelessWidget {
  const LedClock({super.key, required this.clock});

  final ClockController clock;

  @override
  Widget build(BuildContext context) {
    final double clockHeight =
        MediaQuery.of(context).devicePixelRatio * 96 * 1.0;
    final Map<String, bool> ledDisplay = _powerLedElements(
      clock.hrs,
      clock.mins,
      clock.aH,
      clock.aM,
    );

    List<String> activeLeds = [];
    for (String led in ledDisplay.keys) {
      if (ledDisplay[led] ?? false) {
        activeLeds.add(led);
      }
    }

    return Stack(
      children: <Widget>[
        for (String led in activeLeds)
          SvgPicture.asset('assets/images/led_segments/$led.svg',
              height: clockHeight),
      ],
    );
  }
}

Map<String, bool> _powerLedElements(
  int hours,
  int minutes,
  int? alarmH,
  int? alarmM,
) {
  final Map<String, List<bool>> typography = {
    '0': [true, true, true, true, true, true, false],
    '1': [false, true, true, false, false, false, false],
    '2': [true, true, false, true, true, false, true],
    '3': [true, true, true, true, false, false, true],
    '4': [false, true, true, false, false, true, true],
    '5': [true, false, true, true, false, true, true],
    '6': [true, false, true, true, true, true, true],
    '7': [true, true, true, false, false, false, false],
    '8': [true, true, true, true, true, true, true],
    '9': [true, true, true, true, false, true, true],
  };
  final List<bool> elementOff = List.filled(7, false);

  final strHours = hours.toString();
  String? digit1 = (strHours.length > 1) ? strHours[0] : null;
  List<bool> leds1 = typography[digit1] ?? elementOff;
  String digit2 = (strHours.length > 1) ? strHours[1] : strHours[0];
  List<bool> leds2 = typography[digit2] ?? elementOff;

  final strMins = minutes.toString().padLeft(2, '0');
  String digit3 = strMins[0];
  List<bool> leds3 = typography[digit3] ?? elementOff;
  String digit4 = strMins[1];
  List<bool> leds4 = typography[digit4] ?? elementOff;

  return {
    'alarm': alarmH != null && alarmM != null,
    'dots': true,
    '1a': leds1[0],
    '1b': leds1[1],
    '1c': leds1[2],
    '1d': leds1[3],
    '1e': leds1[4],
    '1f': leds1[5],
    '1g': leds1[6],
    '2a': leds2[0],
    '2b': leds2[1],
    '2c': leds2[2],
    '2d': leds2[3],
    '2e': leds2[4],
    '2f': leds2[5],
    '2g': leds2[6],
    '3a': leds3[0],
    '3b': leds3[1],
    '3c': leds3[2],
    '3d': leds3[3],
    '3e': leds3[4],
    '3f': leds3[5],
    '3g': leds3[6],
    '4a': leds4[0],
    '4b': leds4[1],
    '4c': leds4[2],
    '4d': leds4[3],
    '4e': leds4[4],
    '4f': leds4[5],
    '4g': leds4[6],
  };
}
