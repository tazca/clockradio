import 'package:media_kit/media_kit.dart';

class RadioService {
  RadioService(this._player);

  final Player _player;

  factory RadioService.create() {
    final player = Player();
    // Add any Player debugging & setup here
    return RadioService(player);
  }

  void selectStream(String path) async {
    await _player.open(Media(path), play: false);
    await _player.setPlaylistMode(PlaylistMode.loop);
  }

  void play() async {
    await _player.play();
  }

  void stop() async {
    await _player.stop();
  }

  bool isPlaying() {
    return _player.state.playing && _player.state.duration != Duration.zero;
  }
}
