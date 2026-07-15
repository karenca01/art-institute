import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:art_explorer_chicago/screens/exhibitions_list_screen.dart';
import 'package:art_explorer_chicago/screens/detail/exhibition_detail_screen.dart';
import 'package:art_explorer_chicago/screens/detail/artwork_detail_screen.dart';
import 'package:art_explorer_chicago/providers/exhibitions_provider.dart';
import 'package:art_explorer_chicago/providers/artworks_provider.dart';
import 'package:art_explorer_chicago/models/exhibition.dart';
import 'package:art_explorer_chicago/models/artwork.dart';
import 'package:art_explorer_chicago/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    registerFallbackValue(0);
    registerFallbackValue(<int>[]);
  });

  Widget createListTestWidget({required ExhibitionsProvider provider}) {
    return ChangeNotifierProvider<ExhibitionsProvider>.value(
      value: provider,
      child: const MaterialApp(home: ExhibitionsListScreen()),
    );
  }

  Widget createDetailTestWidget({required ExhibitionsProvider provider}) {
    return ChangeNotifierProvider<ExhibitionsProvider>.value(
      value: provider,
      child: const MaterialApp(home: ExhibitionDetailScreen(exhibitionId: 1)),
    );
  }

  group('ExhibitionsListScreen', () {
    testWidgets('displays exhibitions after loading', (tester) async {
      final provider = ExhibitionsProvider(mockApiService);
      when(() => mockApiService.fetchExhibitions(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            Exhibition(
              id: 1,
              title: 'Exhibition One',
              startDate: '2024-01-01',
              endDate: '2024-06-01',
              isCurrent: true,
            ),
            Exhibition(
              id: 2,
              title: 'Exhibition Two',
              startDate: '2023-01-01',
              endDate: '2023-06-01',
            ),
          ]);

      await tester.pumpWidget(createListTestWidget(provider: provider));
      provider.fetchExhibitions();
      await tester.pumpAndSettle();

      expect(find.text('Exhibition One'), findsOneWidget);
      expect(find.text('Exhibition Two'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Current'), findsOneWidget);
    });

    testWidgets('displays empty message when no exhibitions', (tester) async {
      final provider = ExhibitionsProvider(mockApiService);
      when(() => mockApiService.fetchExhibitions(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => []);

      await tester.pumpWidget(createListTestWidget(provider: provider));
      provider.fetchExhibitions();
      await tester.pumpAndSettle();

      expect(find.text('No exhibitions found'), findsOneWidget);
    });

    testWidgets('navigates to detail screen on tap', (tester) async {
      final provider = ExhibitionsProvider(mockApiService);
      when(() => mockApiService.fetchExhibitions(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            Exhibition(id: 42, title: 'Tap Me', startDate: '2024-01-01'),
          ]);
      when(() => mockApiService.fetchExhibition(42))
          .thenAnswer((_) async => Exhibition(id: 42, title: 'Tap Me'));
      when(() => mockApiService.fetchArtworksByIds(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createListTestWidget(provider: provider));
      provider.fetchExhibitions();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(find.byType(ExhibitionDetailScreen), findsOneWidget);
    });
  });

  group('ExhibitionDetailScreen', () {
    testWidgets('displays metadata and associated artworks', (tester) async {
      final provider = ExhibitionsProvider(mockApiService);
      when(() => mockApiService.fetchExhibition(1)).thenAnswer((_) async =>
          Exhibition(
            id: 1,
            title: 'Detailed Exhibition',
            startDate: '2024-01-01',
            endDate: '2024-12-31',
            description: 'A great exhibition.',
            artworkIds: [10, 11],
          ));
      when(() => mockApiService.fetchArtworksByIds(any())).thenAnswer(
        (_) async => [
          Artwork(id: 10, title: 'Artwork A', artistTitle: 'Artist A'),
          Artwork(id: 11, title: 'Artwork B', artistTitle: 'Artist B'),
        ],
      );

      await tester.pumpWidget(createDetailTestWidget(provider: provider));
      await tester.pumpAndSettle();

      expect(find.text('Detailed Exhibition'), findsOneWidget);
      expect(find.text('A great exhibition.'), findsOneWidget);
      expect(find.text('2024-01-01 – 2024-12-31'), findsOneWidget);
      expect(find.text('Artwork A'), findsOneWidget);
      expect(find.text('Artwork B'), findsOneWidget);
      expect(find.text('Associated Artworks'), findsOneWidget);
    });

    testWidgets('shows message when no associated artworks', (tester) async {
      final provider = ExhibitionsProvider(mockApiService);
      when(() => mockApiService.fetchExhibition(1)).thenAnswer((_) async =>
          Exhibition(
            id: 1,
            title: 'Empty Exhibition',
            startDate: '2024-01-01',
            artworkIds: const [],
          ));
      when(() => mockApiService.fetchArtworksByIds(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createDetailTestWidget(provider: provider));
      await tester.pumpAndSettle();

      expect(find.text('Empty Exhibition'), findsOneWidget);
      expect(
        find.text('No associated artworks available for this exhibition.'),
        findsOneWidget,
      );
    });

    testWidgets('tap on associated artwork opens ArtworkDetailScreen',
        (tester) async {
      final provider = ExhibitionsProvider(mockApiService);
      when(() => mockApiService.fetchExhibition(1)).thenAnswer((_) async =>
          Exhibition(
            id: 1,
            title: 'Linked Exhibition',
            startDate: '2024-01-01',
            artworkIds: [10],
          ));
      when(() => mockApiService.fetchArtworksByIds(any())).thenAnswer(
        (_) async => [
          Artwork(id: 10, title: 'Navigable Artwork'),
        ],
      );

      await tester.pumpWidget(createDetailTestWidget(provider: provider));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Navigable Artwork'));
      await tester.tap(find.text('Navigable Artwork'));
      await tester.pumpAndSettle();

      expect(find.byType(ArtworkDetailScreen), findsOneWidget);
    });
  });
}
