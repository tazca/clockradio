import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' show PointerDeviceKind;

import 'clock/clock_controller.dart';
import 'clock/clock_view.dart';
import 'location/location_view.dart';
import 'radio/radio_controller.dart';
import 'radio/radio_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class ClockRadio extends StatelessWidget {
  const ClockRadio({
    super.key,
    required this.clock,
    required this.radio,
    required this.settings,
  });

  final ClockController clock;
  final RadioController radio;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (BuildContext context, Widget? child) {
        // Settings have changed:
        if (settings.alarmSet) {
          clock.setAlarm(settings.alarm);
        } else {
          clock.setAlarm(null);
        }
        clock.setLocation(
            settings.latitude, settings.longitude);
            
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

          // Allow dragging PageView with a mouse
          scrollBehavior: MouseAndTouchDragBehavior(),

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case LocationView.routeName:
                    return LocationView(settings: settings);
                  default:
                    return PageView(
                      controller: PageController(initialPage: 1),
                      physics: const SnappyPageViewScrollPhysics(),
                      children: <Widget>[
                        RadioView(
                          radio: radio,
                          settings: settings,
                        ),
                        ListenableBuilder(
                          listenable: clock,
                          builder: (BuildContext context, Widget? child) {
                            return ClockView(
                              clock: clock.buildClock(),
                              radio: radio,
                              showIntro: settings.intro,
                            );
                          },
                        ),
                        SettingsView(
                          settings: settings,
                        ),
                      ],
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

class MouseAndTouchDragBehavior extends MaterialScrollBehavior {
  /// Allow dragging PageView with a mouse
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

// https://stackoverflow.com/questions/60320972/in-flutter-how-to-make-pageview-scroll-faster-the-animation-seems-to-be-slow-an
class SnappyPageViewScrollPhysics extends ScrollPhysics {
  const SnappyPageViewScrollPhysics({super.parent});

  @override
  SnappyPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnappyPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 0.8,
      );
}
