import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class KAudioPlayer {
  static KAudioPlayer? _instance;

  late List<String> _list;

  // Real audio player
  AudioPlayer? _player;

  // Media path, which is playing or cached
  String _path = "";

  // Media duration, initialize when setUrl
  late Duration _duration;

  KAudioPlayer._internal() {
    _player = AudioPlayer();
    _list = List.empty();
  }

  static KAudioPlayer getInstance() {
    _instance ??= KAudioPlayer._internal();
    return _instance!;
  }

  AudioPlayer getPlayer() {
    return _player!;
  }

  Future<void> setMediaUrl({String? url}) async {
    // Check if it's same media
    debugPrint('set url:$url');

    // Update media path and reset AudioPlayer
    if (url != null) {
      _path = url;
    }
  }

  Future<void> play({String? url}) async {
    if (url != null) {
      await setMediaUrl(url: url);
    }
    if (_player != null) {
      final player = _player!;
      player.play(UrlSource(_path)).then((_) {
        // 获取音频时长
        player.getDuration().then((time) {
          _duration = time ?? const Duration();
        });
      });
      // Set looper
      if (_list.isNotEmpty) {
        player.onPlayerComplete.listen((onComplete) {});
      }
    }
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

  Future<Duration> getDuration() async {
    final time = await _player?.getDuration();
    _duration = time ?? const Duration();
    return _duration;
  }
}
