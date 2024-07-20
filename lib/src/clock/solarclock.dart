import 'dart:math';

import 'package:flutter/material.dart';

import 'clock.dart';

@immutable
class SolarClock extends Clock {
  const SolarClock({
    super.key,
    required super.hours,
    required super.minutes,
    super.alarmH,
    super.alarmM,
    required this.tzOffset,
    required this.nthDayOfYear,
    required this.userLatitude,
    required this.userLongitude,
  });

  final Duration tzOffset;
  final int nthDayOfYear;
  final double userLatitude;
  final double userLongitude;

  factory SolarClock.now({Clock? old, int? alarmH, int? alarmM}) {
    final int hrs = DateTime.now().hour;
    final int mins = DateTime.now().minute;
    final Duration tz = DateTime.now().timeZoneOffset;
    final daysSinceJan1 = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1, 0, 0))
        .inDays;

    return SolarClock(
      hours: hrs,
      minutes: mins,
      alarmH: old?.alarmH ?? alarmH,
      alarmM: old?.alarmM ?? alarmM,
      tzOffset: tz,
      nthDayOfYear: daysSinceJan1 + 1,
      userLatitude: 61.5,
      userLongitude: 23.75,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Clockface is a square (for now)
    final double maximumSize = min(
        MediaQuery.sizeOf(context).height, MediaQuery.sizeOf(context).width);
    final double optimumSize =
        MediaQuery.of(context).devicePixelRatio * 96 * 2.5;
    final double clockSize =
        (maximumSize > optimumSize) ? optimumSize : maximumSize;

    return CustomPaint(
      painter: SolarGraphic(nthDayOfYear, hours, minutes, alarmH, alarmM,
          tzOffset.inMinutes, userLatitude, userLongitude),
      size: Size(clockSize, clockSize),
    );
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
    this._userLongitude,
    this._userLatitude,
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

  @override
  void paint(Canvas canvas, Size size) {
    const double pi = 3.141592;

    // Assuming perfectly circular orbit, solar noon is at 12.00 UTC on 0° E/W,
    // and each 15° added/removed is an hour.
    // At 23.75° E, sun is at 0° at 10.25 UTC, so offset is minus 2 hours and plus 25 minutes.
    final double sNoonOffset = -(_userLatitude / 15.0);
    final int sNoonOffsetH = sNoonOffset.floor();
    final int sNoonOffsetM = ((sNoonOffset - sNoonOffsetH) * 60).round();

    // Sun angle relative to solar noon. At 12.35 local time, -60 minutes + 10 minutes = -50min.
    int hoursToSolarMinutes(int h) {
      return ((h - (_tzOffsetM ~/ 60)) - (12 + sNoonOffsetH)) * 60;
    }

    int minutesToSolarMinutes(int m) {
      return (m - (_tzOffsetM % 60)) - (0 + sNoonOffsetM);
    }

    final double sunRadians =
        (hoursToSolarMinutes(_hours) + minutesToSolarMinutes(_mins)) /
            (12 * 60) *
            pi;
    final double? alarmRadians = (_alarmH != null && _alarmM != null)
        ? (hoursToSolarMinutes(_alarmH) + minutesToSolarMinutes(_alarmM)) /
            (12 * 60) *
            pi
        : null;

    // Sun declination uses a well-known approximation, and day-night line & user dot are
    // relative to earth radius.
    final double sunDeclination =
        -23.45 * cos((2 * pi / 365) * (_nthDayOfYear + 10));
    final double dayNightRatio = sin(sunDeclination / 180 * pi);
    final double userDot = 1 - cos(_userLongitude / 180 * pi);

    //print("$_nthDayOfYear $sunDeclination $dayNightRatio, $userDot");

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

    // Day side from which southernSolsticeRect is substituted from
    // or northernSolsticeRect added to
    final Rect daySideRect = Offset(earthMargin, earthMargin) &
        Size(earthRadius * 2, earthRadius * 2);
    canvas.drawArc(
      daySideRect,
      pi,
      pi,
      true,
      Paint()
        ..color = daySideColor
        ..style = PaintingStyle.fill,
    );

    final double ellipseHalfHeight = earthRadius * dayNightRatio;
    final Color ellipseColor =
        (sunDeclination >= 0.0) ? daySideColor : Colors.black;
    final Rect ellipseRect =
        Offset(earthMargin, earthMargin + (earthRadius - ellipseHalfHeight)) &
            Size(earthRadius * 2, ellipseHalfHeight * 2);
    canvas.drawOval(
      ellipseRect,
      Paint()
        ..color = ellipseColor
        ..style = PaintingStyle.fill,
    );

    // Now, let's rotate Earth & sun to correct time before adding user dot
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(-sunRadians);
    canvas.translate(-size.width * 0.5, -size.height * 0.5);

    // User dot
    canvas.drawCircle(
      Offset(earthMargin + earthRadius, earthMargin + earthRadius * userDot),
      size.width * 0.015,
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
