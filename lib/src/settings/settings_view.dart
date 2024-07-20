import 'package:flutter/material.dart';

import '../clock/clock.dart' show ClockFace;

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).devicePixelRatio * 96 * 2.5),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              DropdownButton<ClockFace>(
                // Read the selected themeMode from the controller
                value: controller.clockFace,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: controller.updateClockFace,
                items: const [
                  DropdownMenuItem(
                    value: ClockFace.led,
                    child: Text('LED face'),
                  ),
                  DropdownMenuItem(
                    value: ClockFace.solar,
                    child: Text('Solar face'),
                  ),
                ],
              ),
              DropdownButton<String>(
                  value: controller.radioStation,
                  onChanged: controller.updateRadioStation,
                  items: const [
                    DropdownMenuItem(
                      value: "assets/sounds/ping.mp3",
                      child: Text('Ping'),
                    ),
                    DropdownMenuItem(
                      value: "https://radio.plaza.one/opus",
                      child: Text('Nightwave plaza'),
                    ),
                    DropdownMenuItem(
                      value:
                          "https://yleradiolive.akamaized.net/hls/live/2027718/in-YleTampere/256/variant.m3u8",
                      child: Text('YLE Suomi Tampere'),
                    ),
                  ]),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      initialValue: controller.alarmH.toString(),
                      onChanged: (String value) {
                        if (value == '') {
                          controller.updateAlarmH(null);
                        } else {
                          controller.updateAlarmH(int.parse(value));
                        }
                      },
                    ),
                  ),
                  const Text(':'),
                  Expanded(
                    child: TextFormField(
                      initialValue: controller.alarmM.toString(),
                      onChanged: (String value) {
                        if (value == '') {
                          controller.updateAlarmM(null);
                        } else {
                          controller.updateAlarmM(int.parse(value));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
