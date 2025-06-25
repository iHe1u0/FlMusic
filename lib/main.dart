import 'package:flmusic/l10n/app_localizations.dart' show AppLocalizations;
import 'package:flmusic/pages/music_list.dart';
import 'package:flmusic/pages/play_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: AppLocalizations.of(context)!.login,
      theme: ThemeData(
        primarySwatch: Colors.blue, // 浅色模式的主色
        brightness: Brightness.light, // 浅色模式
        fontFamily: 'MiSans',
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green, // 深色模式的主色
        brightness: Brightness.dark, // 深色模式
      ),
      themeMode: ThemeMode.system, // 跟随系统自动切换主题
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('zh'), // Chinese
      ],
      routes: {
        "/": (context) => const LoginPage(),
        "/music_list": (context) => const MusicListPage(),
        "/player_ui": (context) => const PlayUi(),
      },
    );
  }
}
