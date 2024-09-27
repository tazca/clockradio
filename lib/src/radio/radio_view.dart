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
    const double minHeight = 1.0 * 96 * 3.0;
    const double minWidth = 1.0 * 96 * 4.8;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: minHeight,
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
                        SizedBox(height: 16.0),
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
        const Text('Play'),
        SizedBox(width: 10.0),
        Expanded(
          child: DropdownButton<String>(
            value: settings.radioStation,
            onChanged: (String? path) {
              settings.updateRadioStation(path);
              if (radio.isPlaying()) {
                radio.stop();
                radio.play();
              }
            },
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
        SizedBox(width: 8.0),
        FilledButton.tonal(
          onPressed: settings.radioStation != SettingsController.fallbackStation
              ? () async {
                  await settings.removeRadioStation(settings.radioStation);
                  if (radio.isPlaying()) {
                    radio.stop();
                    radio.play();
                  }
                }
              : null,
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
            const Text('Add'),
            SizedBox(width: 12.0),
            Expanded(
              child: DropdownButton<String>(
                onChanged: (String? str) {},
                value: 'Custom',
                isExpanded: true,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                      value: 'Custom', child: Text('radio station from URL')),
                ],
              ),
            ),
            SizedBox(width: 107.0),
          ],
        ),
        Row(
          children: <Widget>[
            const Text('URL'),
            SizedBox(width: 12.0),
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
            SizedBox(width: 16.0),
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
            SizedBox(width: 18.0),
          ],
        ),
      ],
    );
  }
}
