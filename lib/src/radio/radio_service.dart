import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_libs_audio/media_kit_libs_audio.dart';

class RadioService {
  RadioService(this._player);
  final Player _player;

  factory RadioService.create() {
    final player = Player();
    player.stream.playlist.listen((e) => print('playlist: $e'));
    player.stream.playing.listen((e) => print('playing: $e'));
    player.stream.completed.listen((e) => print('completed: $e'));
    // player.stream.position.listen((e) => print('position: $e'));
    player.stream.duration.listen((e) => print('duration: $e'));
    player.stream.volume.listen((e) => print('volume: $e'));
    player.stream.rate.listen((e) => print('rate: $e'));
    player.stream.pitch.listen((e) => print('pitch: $e'));
    player.stream.buffering.listen((e) => print('buffering: $e'));
    return RadioService(player);
  }

  Future<void> selectStream(String path) async {
    print('Selecting $path');
    final playable = Media(path);
    await _player.open(playable, play: false);
  }
  Future<void> play() async {
    print('Pressing play');
    await _player.play();
  }
  Future<void> stop() async {
    print('Pressing stop');
    await _player.stop();
  }  

  bool isPlaying() {
    return _player.state.playing;
  }
}
