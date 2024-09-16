import 'package:flutter/material.dart';

import '/src/settings/settings_controller.dart';
import '/src/utils/platform_aware_image.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class LocationView extends StatelessWidget {
  LocationView({
    super.key,
    required this.settings,
  });

  static const routeName = '/location';

  final SettingsController settings;
  final TextEditingController textLat = TextEditingController();
  final TextEditingController textLong = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textLat.text = settings.latitude.toString();
    textLat.selection = TextSelection.collapsed(offset: textLat.text.length);
    textLong.text = settings.longitude.toString();
    textLong.selection = TextSelection.collapsed(offset: textLong.text.length);

    return ListenableBuilder(
      listenable: settings,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                const Text('Latitude: '),
                Expanded(
                  child: TextField(
                    controller: textLat,
                    onChanged: (String value) {
                      if (value == '') {
                        settings.updateLatitude(0.0);
                      } else {
                        try {
                          double latitude = double.parse(value);
                          if (latitude > 90.0) {
                            latitude = 90.0;
                          } else if (latitude < -90.0) {
                            latitude = -90.0;
                          }
                          settings.updateLatitude(latitude);
                        } catch (e) {
                          settings.updateLatitude(0.0);
                        }
                      }
                    },
                  ),
                ),
                const Text('Longitude: '),
                Expanded(
                  child: TextField(
                    controller: textLong,
                    onChanged: (String value) {
                      if (value == '') {
                        settings.updateLongitude(0.0);
                      } else {
                        try {
                          double longitude = double.parse(value);
                          if (longitude > 180.0) {
                            longitude = 180.0;
                          } else if (longitude < -180.0) {
                            longitude = -180.0;
                          }
                          settings.updateLongitude(longitude);
                        } catch (e) {
                          settings.updateLongitude(0.0);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Material(
                  child: Stack(
                    children: <Widget>[
                      LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return _userDot(
                            constraints.maxWidth, constraints.maxHeight);
                      }),
                      Ink.image(
                        fit: BoxFit.fill,
                        image: platformAwareImageProvider(
                            'assets/images/worldmap.png'),
                        child: InkWell(
                          onTapUp: (TapUpDetails details) {
                            _updateLocation(details, context.size);
                            textLat.text = settings.latitude.toString();
                            textLong.text = settings.longitude.toString();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _updateLocation(TapUpDetails details, Size? mapWidgetSize) {
    final double initialLongitude = details.localPosition.dx;
    final double initialLatitude = details.localPosition.dy;

    // The date line does not go exactly at map's edges: Greenwich
    // is about 1/40 of the map's width left of center.
    const double longitudeOffset = 23.75 / 853;

    if (mapWidgetSize != null) {
      double overflowingLongitude =
          ((initialLongitude + longitudeOffset * mapWidgetSize.width) /
                  mapWidgetSize.width *
                  360 -
              180);

      if (overflowingLongitude > 180) {
        overflowingLongitude -= 360;
      }
      final double longitude = overflowingLongitude;
      final double latitude =
          (initialLatitude / mapWidgetSize.height * 180 - 90) * (-1);

      settings.updateLatitude((latitude * 100).roundToDouble() / 100);
      settings.updateLongitude((longitude * 100).roundToDouble() / 100);
    }
  }

  Widget _userDot(double w, double h) {
    // Location to x and y, ie. an inverse of _updateLocation
    const double longitudeOffset = 23.75 / 853;

    double x = ((settings.longitude + 180) / 360 * w - longitudeOffset * w);
    double y = ((-settings.latitude) + 90) / 180 * h;

    return CustomPaint(
      painter: DotGraphic(
        x,
        y,
      ),
      size: Size(w, h),
    );
  }
}

@immutable
class DotGraphic extends CustomPainter {
  const DotGraphic(
    this._x,
    this._y,
  );

  final double _x;
  final double _y;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(_x, _y),
      size.width * 0.0025,
      Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(DotGraphic oldDelegate) {
    return oldDelegate._x != _x || oldDelegate._y != _y;
  }
}
