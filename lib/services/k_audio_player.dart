import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> setMediaUrl({String? url}) async {
    // Check if it's same media
    debugPrint('set url:$url');

    // Update media path and reset AudioPlayer
    if (url != null) {
      _path = url;
    }

    // 获取音频时长
    _duration = await _player?.getDuration() ?? const Duration();
  }

  Future<void> play({String? url}) async {
    if (url != null) {
      await setMediaUrl(url: url);
    }
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
