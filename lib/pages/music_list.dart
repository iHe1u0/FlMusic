import 'package:flmusic/common/global.dart';
import 'package:flmusic/models/audio_file.dart';
import 'package:flmusic/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

typedef WebFile = webdav.File;

class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late webdav.Client _client;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _client = Global.getServer();
    // _client.mkdir(dirPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (url.isEmpty || user.isEmpty || password.isEmpty) {
    //   return const ErrorDisplay(errorMessage: 'Wrong Parameters!');
    // }
    return Scaffold(
      body: FutureBuilder<List<WebFile>>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ErrorDisplay(errorMessage: 'Error: ${snapshot.error}');
          } else {
            return _buildListView(context, snapshot.data ?? []);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.upload_file),
      ),
    );
  }

  Future<List<WebFile>> _getData() {
    return _client.readDir("/");
  }

  Widget _buildListView(BuildContext context, List<WebFile> list) {
    return FutureBuilder<List<AudioFile>>(
      future: _sortList(list),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const ErrorDisplay(errorMessage: '没找到文件');
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final file = data[index];
            return ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(file.title ?? '未知歌曲'),
              subtitle: Text(file.artist ?? '未知艺术家'),
              onTap: () => _playMusic(file),
            );
          },
        );
      },
    );
  }

  void _playMusic(AudioFile file) {
    Navigator.pushNamed(context, "/player_ui", arguments: file);
  }

  Future<List<AudioFile>> _sortList(List<WebFile> src) async {
    final List<AudioFile> des = [];
    for (final file in src) {
      if (file.path != null) {
        final mimeType = lookupMimeType(file.path!);
        if (mimeType?.startsWith('audio/') == true) {
          // final metadata = await readMetadata(File(url + file.path!), getImage: false);
          // readMetadata(File(url + file.path!), getImage: false)
          //     .then((metadata) {
          //   des.add(AudioFile(file.path!,
          //       title: metadata.title, songer: metadata.album ?? '未知艺术家'));
          // });
          des.add(AudioFile("http://raspberrypi:10924/index.php/dav/my/${file.path!}"));
        }
      }
    }
    return des;
  }
}
