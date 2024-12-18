import 'package:flutter/material.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class Global {
  static String? _dir;
  static webdav.Client? _client;

  static webdav.Client getServer() {
    return _client!;
  }

  static String getCurrentDir() => _dir!;

  static void setCurrentDir(String dir) {
    _dir = dir;
  }

  static Future init(String url, String user, String password) async {
    _dir = url;
    _client = webdav.newClient(_dir!, user: user, password: password, debug: true);
    debugPrint("$url----$user----$password");
  }
}
