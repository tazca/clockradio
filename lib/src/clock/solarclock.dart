import 'dart:math';

import 'package:flutter/material.dart';

import 'clock_controller.dart';

@immutable
class SolarClock extends StatelessWidget {
  const SolarClock({
    super.key,
    required this.clock,
  });
  final ClockController clock;

  @override
  Widget build(BuildContext context) {
    // Clockface is a square (for now)
    final double maximumSize = min(
        MediaQuery.sizeOf(context).height, MediaQuery.sizeOf(context).width);
    final double optimumSize =
        MediaQuery.of(context).devicePixelRatio * 96 * 2.5;
    final double clockSize =
        (maximumSize > optimumSize) ? optimumSize : maximumSize;

    final Widget built = CustomPaint(
      painter: SolarGraphic(
        clock.nthDay,
        clock.time.hour,
        clock.time.minute,
        clock.alarm?.hour,
        clock.alarm?.minute,
        clock.tz.inMinutes,
        clock.userLat,
        clock.userLong,
        clock.oledJiggle,
      ),
      size: Size(clockSize, clockSize),
    );

    if (clock.oledJiggle) {
      // Do circular jiggle to avoid burn-in
      const double jiggleSpeed = 30.0; // Divide 60 minutes cleanly.
      final double jiggle = clock.time.minute.toDouble() % jiggleSpeed;

      // At zero jiggle the LED display is at 9 o'clock.
      // As jiggle increases it does a full revolution CCW 0->29.

      // Radius is 15.0. Jiggle is normalized to 0..2 radians.
      // Parametrically, x = r*cos(jiggle), y = r*sin(jiggle)
      // X and Y are -15.0..15.0

      const double pi = 3.141592;
      const double jiggleRadius = 5.0;
      final double t = jiggle / (jiggleSpeed / (2 * pi));
      final double x = jiggleRadius*cos(t);
      final double y = jiggleRadius*sin(t);

      return SizedBox(
        height: clockSize + jiggleRadius * 2,
        width: clockSize + jiggleRadius * 2,
        child: Padding(
          padding: EdgeInsets.only(
            left: jiggleRadius - x,
            right: jiggleRadius + x,
            top: jiggleRadius - y,
            bottom: jiggleRadius + y,
          ),
          child: built,
        ),
      );
    } else {
      return built;
    }
  }
}

@immutable
class SolarGraphic extends CustomPainter {
  const SolarGraphic(
    this._nthDayOfYear,
    this._hours,
    this._mins,
    this._alarmH,
    this._alarmM,
    this._tzOffsetM,
    this._userLatitude,
    this._userLongitude,
    this._oledJiggle,
  );

  final int _nthDayOfYear;
  final int _hours;
  final int _mins;
  final int? _alarmH;
  final int? _alarmM;
  // Timezone offsets can be half-hours too.
  final int _tzOffsetM;
  final double _userLatitude;
  final double _userLongitude;
  final bool _oledJiggle;

  @override
  void paint(Canvas canvas, Size size) {
    const double pi = 3.141592;
    // Assuming perfectly circular orbit, solar noon is at 12.00 UTC on 0° E/W,
    // and each 15° added/removed is an hour.
    // Ie. at 23.75° E, sun is at 0° at 10.25 UTC, so offset is minus 2 hours and plus 25 minutes.
    final double sNoonOffset = -(_userLongitude / 15.0);
    final int sNoonOffsetH = sNoonOffset.floor();
    final int sNoonOffsetM = ((sNoonOffset - sNoonOffsetH) * 60).round();

    // Current time relative to solar noon. At 9.35 UTC, -60 minutes
    int hoursToSolarMinutes(int h) {
      return ((h - (_tzOffsetM ~/ 60)) - (12 + sNoonOffsetH)) * 60;
    }

    // +10 minutes -> -50 minutes
    int minutesToSolarMinutes(int m) {
      return (m - (_tzOffsetM % 60)) - (0 + sNoonOffsetM);
    }

    // -50 minutes -> -12.5° -> -pi/14.4
    final double sunRadians =
        (hoursToSolarMinutes(_hours) + minutesToSolarMinutes(_mins)) /
            (12 * 60) *
            pi;
    // Same for alarm time instead of current time
    final double? alarmRadians = (_alarmH != null && _alarmM != null)
        ? (hoursToSolarMinutes(_alarmH) + minutesToSolarMinutes(_alarmM)) /
            (12 * 60) *
            pi
        : null;

    // Calculating sun declination uses a well-known approximation
    // Day-night line & user dot are relative to earth radius.
    final double sunDeclination =
        -23.45 * cos((2 * pi / 365) * (_nthDayOfYear + 10));
    final double dayNightRatio = sin(sunDeclination / 180 * pi);
    final double userDot = 1 - cos(_userLatitude / 180 * pi);

    double earthRadius = size.height * 0.3;
    double earthMargin = size.height * 0.2;
    double sunRadius = size.height * 0.05;

    // The user dot we add at the end (to have it Z-ordered front) will
    // be in static place, so let's draw time-sensitive bits
    // (hollow sun (alarm), sun, day-night split) rotated, and then rotate back for the dot.
    if (alarmRadians != null) {
      canvas.translate(size.width * 0.5, size.height * 0.5);
      canvas.rotate(alarmRadians);
      canvas.translate(-size.width * 0.5, -size.height * 0.5);

      canvas.drawCircle(
        Offset(earthMargin + earthRadius, sunRadius + sunRadius * 0.15),
        sunRadius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke,
      );

      // avoid doing two sets of translation-rotations:
      canvas.translate(size.width * 0.5, size.height * 0.5);
      canvas.rotate(-alarmRadians + sunRadians);
      canvas.translate(-size.width * 0.5, -size.height * 0.5);
    } else {
      canvas.translate(size.width * 0.5, size.height * 0.5);
      canvas.rotate(sunRadians);
      canvas.translate(-size.width * 0.5, -size.height * 0.5);
    }

    // Sun
    canvas.drawCircle(
      Offset(earthMargin + earthRadius, sunRadius + sunRadius * 0.15),
      sunRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    // Earth
    canvas.drawCircle(
      Offset(earthMargin + earthRadius, earthMargin + earthRadius),
      earthRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke,
    );

    const Color daySideColor = Color.fromARGB(255, 180, 180, 180);
    final PaintingStyle daySideFill =
        _oledJiggle ? PaintingStyle.stroke : PaintingStyle.fill;

    // Day side from which southernSolsticeRect is substituted from
    // or northernSolsticeRect added to
    final Rect daySideRect = Offset(earthMargin, earthMargin) &
        Size(earthRadius * 2, earthRadius * 2);
    canvas.drawArc(
      daySideRect,
      pi,
      pi,
      false,
      Paint()
        ..color = daySideColor
        ..style = daySideFill,
    );
    final double ellipseHalfHeight = earthRadius * dayNightRatio;
    final bool dayIsLonger = sunDeclination >= 0.0 && _userLatitude >= 0.0 ||
                  sunDeclination < 0.0 && _userLatitude < 0.0;
    final Rect ellipseRect =
        Offset(earthMargin, earthMargin + (earthRadius - ellipseHalfHeight)) &
            Size(earthRadius * 2, ellipseHalfHeight * 2);

    if (_oledJiggle) {
      canvas.drawArc(
        ellipseRect,
        dayIsLonger ? 0 : pi,
        pi,
        false,
        Paint()
          ..color = daySideColor
          ..style = PaintingStyle.stroke,
      );
    } else {
      final Color ellipseColor = dayIsLonger
              ? daySideColor
              : Colors.black;
      canvas.drawOval(
        ellipseRect,
        Paint()
          ..color = ellipseColor
          ..style = PaintingStyle.fill,
      );
    }

    // Now, let's rotate Earth & sun to correct time before adding user dot
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(-sunRadians);
    canvas.translate(-size.width * 0.5, -size.height * 0.5);

    // User dot
    canvas.drawCircle(
      Offset(earthMargin + earthRadius, earthMargin + earthRadius * userDot),
      size.width * 0.012,
      Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill,
    );
  }

  // Although SolarGraphic is immutable & remade with every new SolarClock,
  // canvas is still only repainted if shouldRepaint is true.
  @override
  bool shouldRepaint(SolarGraphic oldDelegate) {
    return oldDelegate._mins != _mins ||
        oldDelegate._alarmH != _alarmH ||
        oldDelegate._alarmM != _alarmM;
  }
}
