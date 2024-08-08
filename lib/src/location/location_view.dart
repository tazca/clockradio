import 'package:flutter/material.dart';

import '/src/settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class LocationView extends StatelessWidget {
  const LocationView({super.key, required this.settingsController});

  static const routeName = '/location';

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                const Text('Latitude: '),
                Text('${settingsController.latitude.toString()}°, '),
                const Text('Longitude: '),
                Text('${settingsController.longitude.toString()}°'),
              ],
            ),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                child: Image.asset('images/worldmap.png'),
                onTapUp: (TapUpDetails details) {
                  _updateLocation(details, context.size);
                },
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
          (initialLongitude + longitudeOffset * mapWidgetSize.width) /
                  mapWidgetSize.width *
                  360 -
              180;
      if (overflowingLongitude > 180) {
        overflowingLongitude -= 360;
      }
      final double longitude = overflowingLongitude;
      final double latitude =
          (initialLatitude / mapWidgetSize.height * 180 - 90) * (-1);

      settingsController.updateLatitude((latitude * 100).roundToDouble() / 100);
      settingsController
          .updateLongitude((longitude * 100).roundToDouble() / 100);
    }
  }
}
