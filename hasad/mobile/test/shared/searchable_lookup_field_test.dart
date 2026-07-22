import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/presentation/widgets/searchable_lookup_field.dart';

void main() {
  testWidgets('SearchableLookupField shows action button when empty and onAction is provided', (tester) async {
    bool actionCalled = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchableLookupField<String>(
            label: 'Test Lookup',
            items: const ['Item 1', 'Item 2'],
            itemLabel: (s) => s,
            onChanged: (_) {},
            actionLabel: 'Create New',
            onAction: () {
              actionCalled = true;
            },
          ),
        ),
      ),
    );

    // Open sheet
    await tester.tap(find.byType(SearchableLookupField<String>));
    await tester.pumpAndSettle();

    // Search for non-existent item
    await tester.enterText(find.byType(TextField), 'NonExistent');
    await tester.pump(const Duration(milliseconds: 600)); // Wait for debounce
    await tester.pumpAndSettle();

    expect(find.text('No results found.'), findsOneWidget);
    expect(find.text('Create New'), findsOneWidget);

    // Tap action button
    await tester.tap(find.text('Create New'));
    await tester.pumpAndSettle();

    expect(actionCalled, isTrue);
    expect(find.byType(BottomSheet), findsNothing); // Should close sheet
  });
}
