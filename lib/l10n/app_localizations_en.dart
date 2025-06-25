// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get account => 'Account';

  @override
  String get password => 'Password';

  @override
  String get password_is_null =>
      'password is null, please input correct password';

  @override
  String get account_is_null => 'account is null, please input correct account';
}
