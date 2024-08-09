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
      child: Align(
        alignment: Alignment.topCenter,
        child: Expanded(
          child: Column(
            children: <Widget>[
              Text(
                  style: DefaultTextStyle.of(context).style.apply(
                        color: Color.fromARGB(255, 192, 192, 192),
                        fontSizeFactor: 1.5,
                      ),
                  'Drag left or right for options'),
              Text(
                  style: DefaultTextStyle.of(context).style.apply(
                        color: Color.fromARGB(255, 192, 192, 192),
                        fontSizeFactor: 1.5,
                      ),
                  'Tap to toggle radio'),
            ],
          ),
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
