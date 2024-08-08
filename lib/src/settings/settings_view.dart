import 'package:flutter/material.dart';

import '/src/clock/clock_controller.dart' show ClockFace;
import '/src/location/location_view.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 300),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Container(
              // color: const Color.fromARGB(255, 32, 32, 32),
              child: ListView(
                children: <Widget>[
                  _alarm(context),
                  _location(context),
                  _clockFace(context),
                  _oled(context),
                  _intro(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _alarm(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () async {
        TimeOfDay? setAlarm = await showTimePicker(
          initialTime: controller.alarm ?? const TimeOfDay(hour: 0, minute: 0),
          context: context,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        controller.updateAlarm(setAlarm);
      },
      child: const Text('Set alarm'),
    );
  }

  Widget _location(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        Navigator.restorablePushNamed(context, LocationView.routeName);
      },
      child: const Text('Set location'),
    );
  }

  Widget _clockFace(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Clock faces'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                controller.updateClockFace(ClockFace.led);
              },
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Ink.image(
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                image: const AssetImage('assets/images/ledclock.png'),
              ),
            ),
            InkWell(
              onTap: () {
                controller.updateClockFace(ClockFace.solar);
              },
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Ink.image(
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                image: const AssetImage('assets/images/solarclock.png'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _oled(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Prevent OLED burn-in'),
        Switch.adaptive(
          onChanged: (x) {
            if (controller.oled) {
              controller.updateOled(false);
            } else {
              controller.updateOled(true);
            }
          },
          value: controller.oled,
        ),
      ],
    );
  }

  Widget _intro(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Show help texts on start'),
        Switch.adaptive(
          onChanged: (x) {
            if (controller.intro) {
              controller.updateIntro(false);
            } else {
              controller.updateIntro(true);
            }
          },
          value: controller.intro,
        ),
      ],
    );
  }
}
