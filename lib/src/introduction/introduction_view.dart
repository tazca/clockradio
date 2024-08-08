import 'package:flutter/material.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _IntroductionView();
}

class _IntroductionView extends State<IntroductionView> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: const Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Text(
          style: TextStyle(color: Color.fromARGB(255, 192, 192, 192)),
          'Drag left or right for options'),
            Text(
          style: TextStyle(color: Color.fromARGB(255, 192, 192, 192)),
          'Tap to toggle radio'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }
}
