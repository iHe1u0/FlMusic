import 'package:flmusic/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // const Key for user and password
  static const String keyUser = "user";
  static const String keyPassword = "password";
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
      Navigator.pushReplacementNamed(context, "/music_list",
          arguments: User(username.isEmpty ? "kc_user" : username));
    }
  }

  @override
  void initState() {
    super.initState();
    _storage
        .read(key: keyUser)
        .then((user) => {_usernameController.text = user ?? ""});
    _storage
        .read(key: keyPassword)
        .then((password) => {_passwordController.text = password ?? ""});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录/Login'),
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
                  decoration: const InputDecoration(labelText: '账号/account'),
                  validator: (value) {
                    if (kDebugMode) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
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
                  decoration: const InputDecoration(labelText: '密码/password'),
                  validator: (value) {
                    if (kDebugMode) {
                      return null;
                    }
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('登录/Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
