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
                    return ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        const Align(
                            alignment: Alignment.center,
                            child: Text('Radio deck')),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: _selectFavoriteStation(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: _addStation(context),
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

  Widget _selectFavoriteStation(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text('Select a station: '),
        Expanded(
          child: DropdownButton<String>(
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
        ),
        FilledButton.tonal(
          onPressed: settings.radioStation != SettingsController.fallbackStation ? () {
            settings.removeRadioStation(settings.radioStation);
          } : null,
          child: const Text('Remove'),
        ),
      ],
    );
  }

  Widget _addStation(BuildContext context) {
    TextEditingController addRadioController = TextEditingController();

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Text('Add a new station: '),
            Expanded(
              child: DropdownButton<String>(
                onChanged: (String? str) {},
                value: 'Custom',
                isExpanded: true,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                      value: 'Custom', child: Text('Radio station URL')),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const Text('URL: '),
            Expanded(
              child: TextField(
                controller: addRadioController,
                onSubmitted: (String value) {
                  if (value == '') {
                    return;
                  } else {
                    settings.addRadioStation(value);
                  }
                },
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                if (addRadioController.text == '') {
                  return;
                } else {
                  settings.addRadioStation(addRadioController.text);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}
