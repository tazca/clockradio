import 'package:flutter/material.dart';

class Introduction extends StatefulWidget {
  const Introduction({
    super.key,
    required this.child,
    required this.intro,
    required this.show,
  });

  final Widget child;
  final Widget intro;
  final bool show;

  @override
  State<StatefulWidget> createState() => _Introduction();
}

class _Introduction extends State<Introduction> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (widget.show) {
      return Stack(
        children: <Widget>[
          widget.child,
          Visibility(visible: _visible, child: widget.intro),
        ],
      );
    } else {
      return widget.child;
    }
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
