import 'package:flutter/material.dart';

import '/src/clock/clock_controller.dart' show ClockFace;
import '/src/location/location_view.dart';
import '/src/utils/platform_aware_image.dart' show platformAwareImageProvider;

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (settings.uiScale ?? 1.0) * 96 * 3.0,
            maxHeight: (settings.uiScale ?? 1.0) * 96 * 3.0,
            minWidth: (settings.uiScale ?? 1.0) * 96 * 4.8,
            maxWidth: (settings.uiScale ?? 1.0) * 96 * 4.8,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _alarm(context),
                      ],
                    ),
                    // const Spacer(),
                    /* const Align(
                      alignment: Alignment.center,
                      child: Text('Clock faces'),
                    ), */
                    const Spacer(),
                    _clockFace(context),
                    // const Spacer(),
                    /* const Align(
                      alignment: Alignment.center,
                      child: Text('Miscellaneous'),
                    ), */
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        Expanded(child: _oled(context)),
                        Expanded(child: _intro(context)),
                      ],
                    ),
                    _uiScale(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _alarm(BuildContext context) {
    return Row(
      children: <Widget>[
        FilledButton.tonal(
          onPressed: () async {
            TimeOfDay? setAlarm = await showTimePicker(
              cancelText: 'Unset',
              confirmText: 'Set alarm',
              initialTime: settings.alarm,
              context: context,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            if (setAlarm == null) {
              settings.updateAlarmSet(false);
            } else {
              settings.updateAlarmSet(true);
              settings.updateAlarm(setAlarm);
            }
          },
          child: settings.alarmSet
              ? const Text('Alarm is set')
              : const Text('No alarm set'),
        ),
      ],
    );
  }

  Widget _location(BuildContext context) {
    return FilledButton.tonal(
      onPressed: (settings.clockFace == ClockFace.solar)
          ? () {
              Navigator.restorablePushNamed(context, LocationView.routeName);
            }
          : null,
      child: const Text('Location'),
    );
  }

  Widget _clockFace(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Material(
            child: Ink.image(
              fit: BoxFit.contain,
              width: 100,
              height: 100,
              image: platformAwareImageProvider('assets/images/ledclock.png'),
              child: InkWell(
                onTap: () {
                  settings.updateClockFace(ClockFace.led);
                },
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Material(
                child: Ink.image(
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  image: platformAwareImageProvider(
                      'assets/images/solarclock.png'),
                  child: InkWell(
                    onTap: () {
                      settings.updateClockFace(ClockFace.solar);
                    },
                  ),
                ),
              ),
            ),
            _location(context),
          ],
        ),
      ],
    );
  }

  Widget _oled(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Text('Prevent OLED burn'),
        Switch.adaptive(
          onChanged: (x) {
            if (settings.oled) {
              settings.updateOled(false);
            } else {
              settings.updateOled(true);
            }
          },
          value: settings.oled,
        ),
      ],
    );
  }

  Widget _intro(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Text('Show intro texts'),
        Switch.adaptive(
          onChanged: (x) {
            if (settings.intro) {
              settings.updateIntro(false);
            } else {
              settings.updateIntro(true);
            }
          },
          value: settings.intro,
        ),
      ],
    );
  }

  Widget _uiScale(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Clock and menu scale'),
        // Slider.adaptive is not showing up on mobile Safari 15
        Slider(
          divisions: 10,
          min: 1.0,
          max: 2.0,
          value: settings.uiScale ?? 1.0,
          onChanged: (double x) => settings.updateUIScale(x),
        ),
      ],
    );
  }
}
