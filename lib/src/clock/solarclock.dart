import 'dart:math';

import 'package:flutter/material.dart';

import 'clock.dart';

@immutable
class SolarClock extends Clock {
  const SolarClock(super.refreshEveryNSeconds, super.hours, super.minutes,
      this.tzOffset, this.nthDayOfYear, this.userLatitude, this.userLongitude);

  final Duration tzOffset;
  final int nthDayOfYear;
  final double userLatitude;
  final double userLongitude;

  factory SolarClock.now() {
    final int hrs = DateTime.now().hour;
    final int mins = DateTime.now().minute;
    final Duration tz = DateTime.now().timeZoneOffset;
    final daysSinceJan1 = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1, 0, 0))
        .inDays;
    // Refresh once per 1° or 4 minutes (24h * 15 = 360).
    return SolarClock(240, hrs, mins, tz, daysSinceJan1 + 1, 61.5, 23.75);
  }

  @override
  Widget makeWidget(double clockHeight) {
    return CustomPaint(
      painter: SolarGraphic(nthDayOfYear, hours, minutes, tzOffset.inMinutes,
          userLatitude, userLongitude),
      size: Size(clockHeight * 2, clockHeight * 2),
    );
  }
}

@immutable
class SolarGraphic extends CustomPainter {
  const SolarGraphic(
    this._nthDayOfYear,
    this._hours,
    this._mins,
    this._tzOffsetM,
    this._userLongitude,
    this._userLatitude,
  );

  final int _nthDayOfYear;
  final int _hours;
  final int _mins;
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
    final int hoursToSolarMinutes =
        ((_hours - (_tzOffsetM ~/ 60)) - (12 + sNoonOffsetH)) * 60;
    final int minutesToSolarMinutes =
        (_mins - (_tzOffsetM % 60)) - (0 + sNoonOffsetM);
    final double sunRadians =
        (hoursToSolarMinutes + minutesToSolarMinutes) / (12 * 60) * pi;

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
    ;
    // The user dot we add at the end (to have it Z-ordered front) will
    // be in static place, so let's draw time-sensitive bits
    // (sun, day-night split) rotated, and then rotate back for the dot.
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(sunRadians);
    canvas.translate(-size.width * 0.5, -size.height * 0.5);
    // Sun
    canvas.drawCircle(
      Offset(earthMargin + earthRadius, sunRadius),
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
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    final double ellipseHalfHeight = earthRadius * dayNightRatio;
    final Color ellipseColor =
        (sunDeclination >= 0.0) ? Colors.white : Colors.black;
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

    // User
    canvas.drawCircle(
      Offset(earthMargin + earthRadius, earthMargin + earthRadius * userDot),
      size.width * 0.015,
      Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.fill,
    );
    /*
    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.2,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
    */
  }

  // Class is immutable & remade for every redraw
  @override
  bool shouldRepaint(SolarGraphic oldDelegate) {
    return false;
  }
}
