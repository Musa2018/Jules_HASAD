import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/config/app_config.dart';
import 'package:mobile/features/farmers/domain/farmer.dart';
import 'package:mobile/features/farmers/domain/gender.dart';
import 'package:mobile/features/farmers/presentation/widgets/farmer_card.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    EnvironmentConfig.setEnvironment(AppEnvironment.dev);
  });

  final testFarmer = Farmer(
    id: 'f1',
    idTypeId: 1,
    idNumber: '123456789',
    firstNameAr: 'أحمد',
    fatherNameAr: 'محمد',
    grandfatherNameAr: 'علي',
    familyNameAr: 'محمود',
    firstNameEn: 'Ahmed',
    fatherNameEn: 'Mohammed',
    grandfatherNameEn: 'Ali',
    familyNameEn: 'Mahmoud',
    birthDate: DateTime(1985, 5, 10),
    gender: Gender.male,
    phoneNumber: '0599123456',
    familySize: 5,
    governorateId: 'G1',
    localityId: 'L1',
    address: 'Street 1',
  );

  testWidgets('FarmerCard shows Farm button instead of Search', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: const Locale('ar'),
          home: Scaffold(
            body: FarmerCard(farmer: testFarmer),
          ),
        ),
      ),
    );

    // Verify "مزرعة" button exists (Arabic)
    expect(find.text('مزرعة'), findsOneWidget);
    expect(find.byIcon(Icons.agriculture), findsOneWidget);

    // Verify "بحث" button does NOT exist
    expect(find.text('بحث'), findsNothing);
  });
}
