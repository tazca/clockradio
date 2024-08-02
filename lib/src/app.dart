import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'clock/clock_controller.dart';
import 'clock/clock_view.dart';
import 'radio/radio_controller.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class ClockRadio extends StatelessWidget {
  const ClockRadio({
    super.key,
    required this.clockController,
    required this.radioController,
    required this.settingsController,
  });

  final ClockController clockController;
  final RadioController radioController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        // Settings have changed:
        clockController.setAlarm(
            settingsController.alarmH, settingsController.alarmM);

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

          // The clock faces currently use mostly true black, so no sense
          // in including options for light mode.
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  default:
                    return ListenableBuilder(
                      listenable: clockController,
                      builder: (BuildContext context, Widget? child) {
                        return ClockView(
                          clock: clockController.buildClock(),
                          radio: radioController,
                        );
                      },
                    );
                }
              },
            );
          },
        );
      },
    );
  }
}
