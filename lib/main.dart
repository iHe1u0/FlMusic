import 'package:flmusic/pages/music_list.dart';
import 'package:flutter/material.dart';

import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '登录/Login',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 浅色模式的主色
        brightness: Brightness.light, // 浅色模式
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepOrange, // 深色模式的主色
        brightness: Brightness.dark, // 深色模式
      ),
      themeMode: ThemeMode.system, // 跟随系统自动切换主题
      routes: {
        "/": (context) => const LoginPage(),
        "/music_list": (context) => const MusicListPage()
      },
    );
  }
}
