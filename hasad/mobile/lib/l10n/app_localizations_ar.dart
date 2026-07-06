// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حصاد';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dashboard => 'لوحة القيادة';

  @override
  String get farmers => 'المزارعون';

  @override
  String get farms => 'المزارع';

  @override
  String get damageReports => 'تقارير الأضرار';

  @override
  String get map => 'الخريطة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get emailRequired => 'يرجى إدخال البريد الإلكتروني.';

  @override
  String get emailInvalid => 'يرجى إدخال بريد إلكتروني صالح.';

  @override
  String get passwordRequired => 'يرجى إدخال كلمة المرور.';

  @override
  String get loginFailed =>
      'فشل تسجيل الدخول. يرجى التحقق من بيانات الاعتماد والمحاولة مرة أخرى.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String welcome(String name) {
    return 'مرحباً، $name';
  }
}
