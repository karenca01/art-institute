// Basic smoke tests for the Art Explorer Chicago navigation shell.

import 'package:flutter_test/flutter_test.dart';

import 'package:art_explorer_chicago/main.dart';

void main() {
  testWidgets('App launches showing the Artworks tab by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // The Artworks placeholder screen should be visible on launch.
    expect(find.text('Artworks'), findsWidgets);
    expect(find.text('Artworks will appear here.'), findsOneWidget);

    // All four navigation destinations should be present.
    expect(find.text('Exhibitions'), findsWidgets);
    expect(find.text('Museum Info'), findsWidgets);
    expect(find.text('Artists'), findsWidgets);
  });

  testWidgets('Tapping a navigation destination switches screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Exhibitions').last);
    await tester.pumpAndSettle();

    expect(find.text('Exhibitions will appear here.'), findsOneWidget);
  });
}
