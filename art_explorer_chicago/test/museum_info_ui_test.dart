import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:art_explorer_chicago/screens/museum_info_screen.dart';
import 'package:art_explorer_chicago/providers/museum_info_provider.dart';
import 'package:art_explorer_chicago/providers/artworks_provider.dart';
import 'package:art_explorer_chicago/models/museum_info.dart';
import 'package:art_explorer_chicago/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    registerFallbackValue(0);
    registerFallbackValue(<int>[]);
  });

  Widget createTestWidget({required MuseumInfoProvider provider}) {
    return ChangeNotifierProvider<MuseumInfoProvider>.value(
      value: provider,
      child: const MaterialApp(home: MuseumInfoScreen()),
    );
  }

  final sampleInfo = MuseumInfo(
    name: 'Art Institute of Chicago',
    address: '111 S Michigan Ave, Chicago, IL 60603',
    hours: {
      'Monday': '11:00 AM – 5:00 PM',
      'Tuesday': 'Closed',
    },
    phone: '+1 (312) 443-3600',
    email: 'info@artic.edu',
    website: 'https://www.artic.edu',
  );

  testWidgets('renders museum info content from API data', (tester) async {
    final provider = MuseumInfoProvider(mockApiService);
    when(() => mockApiService.fetchMuseumInfo())
        .thenAnswer((_) async => sampleInfo);

    await tester.pumpWidget(createTestWidget(provider: provider));
    provider.fetchMuseumInfo();
    await tester.pumpAndSettle();

    expect(find.text('Art Institute of Chicago'), findsOneWidget);
    expect(find.text('111 S Michigan Ave, Chicago, IL 60603'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('11:00 AM – 5:00 PM'), findsOneWidget);
    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
    expect(find.text('Open in Maps'), findsOneWidget);
    expect(find.text('+1 (312) 443-3600'), findsOneWidget);
    expect(find.text('info@artic.edu'), findsOneWidget);
    expect(find.text('https://www.artic.edu'), findsOneWidget);
  });

  testWidgets('shows error state with retry on failure', (tester) async {
    final provider = MuseumInfoProvider(mockApiService);
    when(() => mockApiService.fetchMuseumInfo())
        .thenThrow(Exception('Network error'));

    await tester.pumpWidget(createTestWidget(provider: provider));
    provider.fetchMuseumInfo();
    await tester.pumpAndSettle();

    expect(find.textContaining('Error:'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('tapping Open in Maps does not crash the screen',
      (tester) async {
    final provider = MuseumInfoProvider(mockApiService);
    when(() => mockApiService.fetchMuseumInfo())
        .thenAnswer((_) async => sampleInfo);

    await tester.pumpWidget(createTestWidget(provider: provider));
    provider.fetchMuseumInfo();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open in Maps'));
    await tester.pumpAndSettle();

    // Screen remains intact (link launch is handled and failure is caught).
    expect(find.text('Art Institute of Chicago'), findsOneWidget);
  });
}
