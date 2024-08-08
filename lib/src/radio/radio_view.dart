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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).devicePixelRatio * 96 * 2.0,
            maxHeight: MediaQuery.of(context).devicePixelRatio * 96 * 2.0,
            minWidth: MediaQuery.of(context).devicePixelRatio * 96 * 3.0,
            maxWidth: MediaQuery.of(context).devicePixelRatio * 96 * 3.0,
          ),
          child: ListenableBuilder(
            listenable: settings,
            builder: (BuildContext context, Widget? child) {
              return Column(
                children: <Widget>[
                  const Text('Radio interface'),
                  DropdownButton<String>(
                    value: settings.radioStation,
                    onChanged: settings.updateRadioStation,
                    isExpanded: true,
                    items: settings.radioStations.map<DropdownMenuItem<String>>(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
