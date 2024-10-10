import 'package:audioplayers/audioplayers.dart';

class KAudioPlayer {
  static KAudioPlayer? _instance;
  // Real audio player
  AudioPlayer? _player;
  // Media path, which is playing or cached
  String _path = "";
  // Media duration, initialize when setUrl
  late Duration _duration;

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

  Future<void> init({String? url}) async {
    bool needPlay = false;
    if (url != null) {
      // Use previous data if initialize player with same path
      if (url == _path && _player?.state == PlayerState.paused) {
        needPlay = true;
        _player?.play(UrlSource(url));
        return;
      }
      _path = url;
    }
    if (!needPlay && _player?.state == PlayerState.playing) {
      _player?.stop();
      _player?.release();
      _player = AudioPlayer();
    }
    _player
        ?.getDuration()
        .then((duration) => {_duration = duration ?? const Duration()});
  }

  Future<void> play({String? url}) async {
    await init(url: url);
    await _player?.play(UrlSource(_path));
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
    _path = url;
  }

  PlayerState getPlayerState() {
    return _player!.state;
  }

  Duration getDuration() {
    return _duration;
  }
}
