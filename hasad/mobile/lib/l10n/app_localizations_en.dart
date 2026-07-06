// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HASAD';

  @override
  String get login => 'Login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get farmers => 'Farmers';

  @override
  String get farms => 'Farms';

  @override
  String get damageReports => 'Damage Reports';

  @override
  String get map => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Please enter your email.';

  @override
  String get emailInvalid => 'Please enter a valid email address.';

  @override
  String get passwordRequired => 'Please enter your password.';

  @override
  String get loginFailed =>
      'Login failed. Please check your credentials and try again.';

  @override
  String get logout => 'Logout';

  @override
  String welcome(String name) {
    return 'Welcome, $name';
  }
}
