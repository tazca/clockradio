import 'package:flutter/material.dart';

import '/src/introduction/introduction_view.dart';
import '/src/radio/radio_controller.dart';

class ClockView extends StatelessWidget {
  const ClockView({
    super.key,
    required this.clock,
    required this.radio,
    required this.showIntro
  });

  static const routeName = '/';

  final StatelessWidget clock;
  final RadioController radio;
  final bool showIntro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
      children: <Widget>[
        InkWell(
        hoverColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: () {
          radio.toggle();
        },
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Center(
          child: clock.build(context),
        ),
        ),
        if (showIntro) const IntroductionView(),
      ],
      ),
    );
  } // Widget
}
