import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// user model
class User {
  final String account;

  User(this.account);

  String generateUserKey() {
    if (kDebugMode) {
      return account;
    }
    Uint8List content = const Utf8Encoder().convert(account);
    Digest digest = md5.convert(content);
    return digest.toString();
  }
}
