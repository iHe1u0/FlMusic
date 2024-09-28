import 'package:audioplayers/audioplayers.dart';

class KAudioPlayer {
  static KAudioPlayer? _instance;
  AudioPlayer? _player;

  KAudioPlayer._internal() {
    _player = AudioPlayer();
  }

  static KAudioPlayer getInstance() {
    _instance ??= KAudioPlayer._internal();
    return _instance!;
  }

  Future<void> play(String url) async {
    if (_player?.state == PlayerState.playing) {
      _player?.stop();
      _player?.release();
    }
    await _player?.play(UrlSource(url));
  }

  Future<void> pause() async {
    await _player?.pause();
  }

  Future<void> stop() async {
    await _player?.stop();
  }
}
