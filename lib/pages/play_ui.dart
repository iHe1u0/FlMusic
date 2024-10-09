import 'package:audioplayers/audioplayers.dart';
import 'package:flmusic/services/k_audio_player.dart';
import 'package:flmusic/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flmusic/models/audio_file.dart';

class PlayUi extends StatefulWidget {
  const PlayUi({super.key});

  @override
  State<PlayUi> createState() => PlayUiState();
}

class PlayUiState extends State<PlayUi> {
  KAudioPlayer audioPlayer = KAudioPlayer.getInstance();

  bool isPlaying = false;
  double progress = 0.0; // This represents the current position of the audio
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  late AudioFile audioFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    audioFile = ModalRoute.of(context)!.settings.arguments as AudioFile;
    // debugPrint(audioFile.path);
    audioPlayer.play(url: audioFile.path);
  }

  @override
  void initState() {
    super.initState();
    // Listen to state changes
    audioPlayer.getPlayer().onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = (state == PlayerState.playing);
      });
    });

    // Listen to position changes
    audioPlayer.getPlayer().onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });

    // Listen to duration changes
    audioPlayer.getPlayer().onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (audioFile.path.isEmpty) {
      return const ErrorDisplay(errorMessage: "音频加载失败");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(audioFile.title!), // Display the song title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Album art or placeholder
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
                image: audioFile.coverImage != null
                    ? DecorationImage(
                        image: NetworkImage(audioFile.coverImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: audioFile.coverImage == null
                  ? const Icon(
                      Icons.music_note,
                      size: 100,
                      color: Colors.white70,
                    )
                  : null,
            ),
            const SizedBox(height: 24),

            // Song title and artist
            Text(
              audioFile.title!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              audioFile.artist ?? '未知歌手',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Progress bar
            Slider(
              value: currentPosition.inSeconds.toDouble(),
              min: 0,
              max: totalDuration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  currentPosition = Duration(seconds: value.toInt());
                  audioPlayer.getPlayer().seek(currentPosition);
                });
              },
            ),

            // Time indicators (current position / total duration)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(currentPosition)),
                Text(_formatDuration(totalDuration)),
              ],
            ),
            const SizedBox(height: 24),

            // Play / Pause and Forward / Rewind controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {
                    setState(() {
                      progress = (progress - 10)
                          .clamp(0, totalDuration.inSeconds.toDouble());
                      audioPlayer.getPlayer().seek(currentPosition);
                    });
                  },
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.play(url: audioFile.path);
                    }
                  },
                ),
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {
                    setState(() {
                      progress = (progress + 10)
                          .clamp(0, totalDuration.inSeconds.toDouble());
                      audioPlayer.getPlayer().seek(currentPosition);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format duration into mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}
