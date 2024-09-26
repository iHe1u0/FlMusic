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
    // return MaterialApp(
    //   title: 'Flutter Music',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const LoginPage(),
    // );
    return MaterialApp(
      title: 'Flutter Music',
      routes: {
        "/": (context) => const LoginPage(),
        "/music_list": (context) => const MusicListPage()
      },
    );
  }
}
