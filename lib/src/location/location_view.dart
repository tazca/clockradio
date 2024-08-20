import 'package:flutter/material.dart';

import '/src/settings/settings_controller.dart';
import '/src/utils/platform_aware_image.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class LocationView extends StatelessWidget {
  LocationView({super.key, required this.settingsController});

  static const routeName = '/location';

  final SettingsController settingsController;
  final TextEditingController textLat = TextEditingController();
  final TextEditingController textLong = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        textLat.text = settingsController.latitude.toString();
        textLong.text = settingsController.longitude.toString();

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                const Text('Latitude: '),
                Expanded(
                  child: TextFormField(
                    controller: textLat,
                    onFieldSubmitted: (String value) {
                      if (value == '') {
                        settingsController.updateLatitude(0.0);
                      } else {
                        try {
                          double latitude = double.parse(value);
                          if (latitude > 90.0) {
                            latitude = 90.0;
                          } else if (latitude < -90.0) {
                            latitude = -90.0;
                          }
                          settingsController.updateLatitude(latitude);
                        } catch (e) {
                          settingsController.updateLatitude(0.0);
                        }
                      }
                    },
                  ),
                ),
                const Text('Longitude: '),
                Expanded(
                  child: TextFormField(
                    controller: textLong,
                    onFieldSubmitted: (String value) {
                      if (value == '') {
                        settingsController.updateLongitude(0.0);
                      } else {
                        try {
                          double longitude = double.parse(value);
                          if (longitude > 180.0) {
                            longitude = 180.0;
                          } else if (longitude < -180.0) {
                            longitude = -180.0;
                          }
                          settingsController.updateLongitude(longitude);
                        } catch (e) {
                          settingsController.updateLongitude(0.0);
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
                  child: Ink.image(
                    fit: BoxFit.fill,
                    image: platformAwareImageProvider(
                        'assets/images/worldmap.png'),
                    child: InkWell(
                      onTapUp: (TapUpDetails details) {
                        _updateLocation(details, context.size);
                        textLat.text = settingsController.latitude.toString();
                        textLong.text = settingsController.longitude.toString();
                      },
                    ),
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

      settingsController.updateLatitude((latitude * 100).roundToDouble() / 100);
      settingsController
          .updateLongitude((longitude * 100).roundToDouble() / 100);
    }
  }
}
