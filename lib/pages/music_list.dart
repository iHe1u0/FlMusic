import 'package:audioplayers/audioplayers.dart';
import 'package:flmusic/pages/error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:webdav_client/webdav_client.dart';

class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Client _client;

  // config server infomation
  final url = 'http://192.168.0.109:10524/';
  final user = 'kc_user';
  final password = '';
  var dirPath = '/';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // init webdav client
    _client = newClient(url, user: user, password: password, debug: false);
    // create Music dir
    _client.mkdir('/Music');
    dirPath += 'Music';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || user.isEmpty || password.isEmpty) {
      return const ErrorDisplay(errorMessage: 'Wrong Parameters!');
    }
    return Scaffold(
      body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return _buildListView(context, snapshot.data ?? []);
            }
          }),
    );
  }

  Future<List<File>> _getData() {
    return _client.readDir(dirPath);
  }

  Widget _buildListView(BuildContext context, List<File> list) {
    var data = _sortList(list);

    if (kDebugMode) {
      for (final f in data) {
        debugPrint(f.path);
      }
    }

    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final file = data[index];
          return ListTile(
            leading: Icon(
                file.isDir == true ? Icons.folder : Icons.file_present_rounded),
            title: Text(file.name ?? ''),
            subtitle: Text(file.mTime.toString()),
            onTap: () async {
              // debugPrint(file.path);
              dirPath = file.path.toString();
              if (file.isDir == true) {
                _getData().then((newData) {
                  setState(() {
                    data.clear();
                    data.addAll(newData);
                  });
                });
              } else {
                _playMusic(dirPath);
              }
            },
          );
        });
  }

  void _playMusic(String source) {
    final file = url + source;
    final audioPlayer = AudioPlayer();
    audioPlayer.play(UrlSource(file));
  }

  List<File> _sortList(List<File> src) {
    var des = src;
    for (final file in src) {
      if (file.path != null) {
        final mimeType = lookupMimeType(file.path!);
        if (mimeType != null && mimeType.startsWith('audio/*')) {
          src.add(file);
        }
      }
    }
    return des;
  }
}
