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

  @override
  String get welcomeToHasad => 'مرحباً بك في حصاد';

  @override
  String get pleaseSignIn => 'يرجى تسجيل الدخول';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get addFarmer => 'إضافة مزارع';

  @override
  String get editFarmer => 'تعديل مزارع';

  @override
  String get farmerName => 'اسم المزارع';

  @override
  String get nationalId => 'رقم الهوية';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirmDelete => 'هل أنت متأكد من حذف هذا المزارع؟';

  @override
  String get noFarmers => 'لا يوجد مزارعون.';

  @override
  String get errorLoadingFarmers => 'فشل تحميل المزارعين.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get requiredField => 'هذا الحقل مطلوب.';

  @override
  String get addFarm => 'إضافة مزرعة';

  @override
  String get editFarm => 'تعديل مزرعة';

  @override
  String get farmName => 'اسم المزرعة';

  @override
  String get governorate => 'المحافظة';

  @override
  String get locality => 'التجمع السكاني';

  @override
  String get landArea => 'مساحة الأرض';

  @override
  String get unit => 'الوحدة';

  @override
  String get ownershipType => 'نوع الملكية';

  @override
  String get noFarms => 'لا يوجد مزارع.';

  @override
  String get errorLoadingFarms => 'فشل تحميل المزارع.';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get sendResetLink => 'إرسال رابط التعيين';

  @override
  String get emailSent => 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get enterEmailToReset =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get compensation => 'التعويض';

  @override
  String get calculatedAmount => 'المبلغ المحتسب';

  @override
  String get approvedAmount => 'المبلغ المعتمد';

  @override
  String get remarks => 'ملاحظات';

  @override
  String get status => 'الحالة';

  @override
  String get calculateCompensation => 'احتساب التعويض';

  @override
  String get approve => 'اعتماد';

  @override
  String get paid => 'تم الصرف';

  @override
  String get noCompensation => 'لم يتم احتساب التعويض بعد.';
}
