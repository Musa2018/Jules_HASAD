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

  @override
  String get welcomeToHasad => 'Welcome to HASAD';

  @override
  String get pleaseSignIn => 'Please Sign In';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get usernameOrEmail => 'Username or Email';

  @override
  String get addFarmer => 'Add Farmer';

  @override
  String get editFarmer => 'Edit Farmer';

  @override
  String get farmerName => 'Farmer Name';

  @override
  String get nationalId => 'National ID';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Are you sure you want to delete this farmer?';

  @override
  String get noFarmers => 'No farmers found.';

  @override
  String get errorLoadingFarmers => 'Failed to load farmers.';

  @override
  String get retry => 'Retry';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get addFarm => 'Add Farm';

  @override
  String get editFarm => 'Edit Farm';

  @override
  String get farmName => 'Farm Name';

  @override
  String get governorate => 'Governorate';

  @override
  String get locality => 'Locality';

  @override
  String get landArea => 'Land Area';

  @override
  String get unit => 'Unit';

  @override
  String get ownershipType => 'Ownership Type';

  @override
  String get noFarms => 'No farms found.';

  @override
  String get errorLoadingFarms => 'Failed to load farms.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailSent => 'A reset link has been sent to your email.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get enterEmailToReset =>
      'Enter your email address and we\'ll send you a link to reset your password.';
}
