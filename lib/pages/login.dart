import 'package:flmusic/common/global.dart';
import 'package:flmusic/l10n/app_localizations.dart' show AppLocalizations;
import 'package:flmusic/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // const Key for user and password
  static const String keyUser = "sk_user";
  static const String keyPassword = "sk_password";
  void _login() {
    if (_formKey.currentState?.validate() == true) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      _storage.write(key: keyUser, value: username);
      _storage.write(key: keyPassword, value: password);

      // 模拟登录处理逻辑
      // if (kDebugMode) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //         'Logging in with username: $username and password: $password'),
      //   ));
      // }
      // 跳转页面
      Global.init('http://raspberrypi:10924/index.php/dav/my/我的音乐', username, password).then(
        (_) {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, "/music_list",
                arguments: User(username.isEmpty ? "test" : username));
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _storage.read(key: keyUser).then((user) => {_usernameController.text = user ?? "1"});
    _storage.read(key: keyPassword).then((password) => {_passwordController.text = password ?? "1"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.account,
                  ),
                  validator: (value) {
                    if (kDebugMode) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.account_is_null;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                  ),
                  validator: (value) {
                    if (kDebugMode) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.password_is_null;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  AppLocalizations.of(context)!.login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
