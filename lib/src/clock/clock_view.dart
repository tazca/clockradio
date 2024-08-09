import 'package:flutter/material.dart';

import '../introduction/introduction.dart';
import '/src/radio/radio_controller.dart';

class ClockView extends StatelessWidget {
  const ClockView(
      {super.key,
      required this.clock,
      required this.radio,
      required this.showIntro});

  static const routeName = '/';

  final StatelessWidget clock;
  final RadioController radio;
  final bool showIntro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Builder(builder: (BuildContext context) {
        return Introduction(
          intro: _intro(context),
          show: showIntro,
          child: _clock(context),
        );
      }),
    );
  } // Widget

  Widget _clock(BuildContext context) {
    return InkWell(
      hoverColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: () {
        radio.toggle();
      },
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Center(
        child: clock.build(context),
      ),
    );
  }

  Widget _intro(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
          children: <Widget>[
            Text(
                style: DefaultTextStyle.of(context).style.apply(
                      color: const Color.fromARGB(255, 192, 192, 192),
                      fontSizeFactor: 1.5,
                    ),
                'Drag left or right for options'),
            Text(
                style: DefaultTextStyle.of(context).style.apply(
                      color: const Color.fromARGB(255, 192, 192, 192),
                      fontSizeFactor: 1.5,
                    ),
                'Tap to toggle radio'),
          ],
        ),
    );
  }
}
