import 'package:audioplayers/audioplayers.dart';

class KAudioPlayer {
  static KAudioPlayer? _instance;
  AudioPlayer? _player;

  late String path;

  KAudioPlayer._internal() {
    _player = AudioPlayer();
  }

  static KAudioPlayer getInstance() {
    _instance ??= KAudioPlayer._internal();
    return _instance!;
  }

  AudioPlayer getPlayer() {
    return _player!;
  }

  Future<void> play({String? url}) async {
    if (url != null) {
      path = url;
    }
    if (_player?.state == PlayerState.playing) {
      _player?.stop();
      _player?.release();
    }
    await _player?.play(UrlSource(path));
  }

  Future<void> pause() async {
    await _player?.pause();
  }

  Future<void> stop() async {
    await _player?.stop();
  }

  Future<void> release() async {
    await _player?.release();
  }

  void setUrl(String url) {
    path = url;
  }

  PlayerState getPlayerState() {
    return _player!.state;
  }
}
