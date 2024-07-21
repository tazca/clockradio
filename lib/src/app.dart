import 'package:clockradio/src/clock/ledclock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';

import 'clock/clock_view.dart';
import 'clock/clock.dart';
import 'clock/ledclock.dart';
import 'clock/solarclock.dart';
import 'radio/radio_controller.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class ClockRadio extends StatelessWidget {
  const ClockRadio({
    super.key,
    required this.radioController,
    required this.settingsController,
    required this.clock,
  });

  final RadioController radioController;
  final SettingsController settingsController;
  final ValueNotifier<Clock> clock;

  factory ClockRadio.create(
      RadioController radioController, SettingsController settingsController) {
    final ClockFace face = settingsController.clockFace;
    late final Clock clock;
    switch (face) {
      case ClockFace.led:
        clock = LedClock.now(
          alarmH: settingsController.alarmH,
          alarmM: settingsController.alarmM,
        );
      case ClockFace.solar:
        clock = SolarClock.now(
          alarmH: settingsController.alarmH,
          alarmM: settingsController.alarmM,
        );
    }
    return ClockRadio(
        radioController: radioController,
        settingsController: settingsController,
        clock: ValueNotifier(clock));
  }

  void _refreshClock() {
    final int startRefresh = DateTime.now().millisecond;
    if (clock.value is LedClock) {
      clock.value = LedClock.now(
          alarmH: settingsController.alarmH,
          alarmM: settingsController.alarmM);
    } else if (clock.value is SolarClock) {
      clock.value = SolarClock.now(
          alarmH: settingsController.alarmH,
          alarmM: settingsController.alarmM);
    } else {
      clock.value = SolarClock.now(
          alarmH: settingsController.alarmH,
          alarmM: settingsController.alarmM);
    }

    if (clock.value.isAlarmRinging) {
      radioController.play();
    }

    final int secs = DateTime.now().second;
    Timer(Duration(seconds: 60 - secs), _refreshClock);
    final int refreshTime = (DateTime.now().millisecond - startRefresh < 0)
        ? DateTime.now().millisecond + 1000 - startRefresh
        : DateTime.now().millisecond - startRefresh;
    print(
        '${clock.value.hours}.${clock.value.minutes}: Finished refreshing ${clock.value} in $refreshTime ms');
    print(
        "Alarm is set for ${clock.value.alarmH}:${clock.value.alarmM}. IsAlarmRinging: ${clock.value.isAlarmRinging}");
  }


  @override
  Widget build(BuildContext context) {
    _refreshClock();
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          //theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          //themeMode: settingsController.themeMode,
          themeMode: ThemeMode.dark,
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  default:
                    return ClockView(
                      clock: clock,
                      radio: radioController,
                    );
                }
              },
            );
          },
        ); // MaterialApp
      },
    );
  }
}
