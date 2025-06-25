// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get login => '登录';

  @override
  String get account => '账号';

  @override
  String get password => '密码';

  @override
  String get password_is_null => '请输入密码';

  @override
  String get account_is_null => '请输入账号';
}
