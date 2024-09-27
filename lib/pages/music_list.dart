import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || user.isEmpty || password.isEmpty) {
      return const Center(child: Text('Wrong parameters'));
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
    var data = list;
    if (data.isNotEmpty) {}
    data.toList()
      .sort((a, b) {
        if ((a.isDir == true) && !(b.isDir == true)) return -1; // 文件夹排在前
        if (!(a.isDir == true) && (b.isDir == true)) return 1; // 文件排在后
        return a.name!.compareTo(b.name!); // 同类按名称排序
      });

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
                _playMusic();
              }
            },
          );
        });
  }

  void _playMusic() {}
}
