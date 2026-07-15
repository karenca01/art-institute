// Basic smoke tests for the Art Explorer Chicago navigation shell.

import 'package:flutter_test/flutter_test.dart';

import 'package:art_explorer_chicago/main.dart';

void main() {
  testWidgets('App launches showing the Artworks tab by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // The Artworks screen (real UI) should be visible on launch.
    expect(find.text('Artworks'), findsWidgets);
    expect(find.text('Search artworks...'), findsOneWidget);

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

    // The Exhibitions screen should be shown and the placeholder gone.
    expect(find.text('Exhibitions'), findsWidgets);
    expect(find.text('Exhibitions will appear here.'), findsNothing);
  });
}
