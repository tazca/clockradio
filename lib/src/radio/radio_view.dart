import 'package:flutter/material.dart';

import '/src/settings/settings_controller.dart';

import 'radio_controller.dart';

class RadioView extends StatelessWidget {
  const RadioView({
    super.key,
    required this.radio,
    required this.settings,
  });

  final RadioController radio;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    // 2.0" x 3.5"
    final double minHeight = MediaQuery.of(context).devicePixelRatio * 96 * 2.0;
    final double minWidth = MediaQuery.of(context).devicePixelRatio * 96 * 3.5;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: minHeight * 2,
            minWidth: minWidth,
            maxWidth: minWidth * 2,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListenableBuilder(
                  listenable: settings,
                  builder: (BuildContext context, Widget? child) {
                    return Column(
                      children: <Widget>[
                        const Text('Radio interface'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: minHeight * 0.6,
                                maxWidth: minWidth,
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Select station'),
                                  Text('Add station'),
                                ],
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: minHeight * 0.5,
                                maxWidth: minWidth,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  DropdownButton<String>(
                                    value: settings.radioStation,
                                    onChanged: settings.updateRadioStation,
                                    isExpanded: true,
                                    items: settings.radioStations
                                        .map<DropdownMenuItem<String>>(
                                      (String station) {
                                        return DropdownMenuItem(
                                          value: station,
                                          child: Text(station),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  TextField(onSubmitted: (String? value) {
                                    if (value == null || value == '') {
                                      return;
                                    } else {
                                      settings.addRadioStation(value);
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
