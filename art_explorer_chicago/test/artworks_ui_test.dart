import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:art_explorer_chicago/screens/artworks_list_screen.dart';
import 'package:art_explorer_chicago/screens/detail/artwork_detail_screen.dart';
import 'package:art_explorer_chicago/providers/artworks_provider.dart';
import 'package:art_explorer_chicago/models/artwork.dart';
import 'package:art_explorer_chicago/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    registerFallbackValue(0);
  });

  Widget createTestWidget({required ArtworksProvider provider}) {
    return ChangeNotifierProvider<ArtworksProvider>.value(
      value: provider,
      child: const MaterialApp(home: ArtworksListScreen()),
    );
  }

  group('ArtworksListScreen', () {
    testWidgets('displays artworks grid after loading', (tester) async {
      final provider = ArtworksProvider(mockApiService);
      when(() => mockApiService.fetchArtworks(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => [
                Artwork(id: 1, title: 'Artwork 1', artistTitle: 'Artist 1'),
                Artwork(id: 2, title: 'Artwork 2', artistTitle: 'Artist 2'),
              ]);

      await tester.pumpWidget(createTestWidget(provider: provider));
      provider.fetchArtworks();
      await tester.pumpAndSettle();

      expect(find.text('Artwork 1'), findsOneWidget);
      expect(find.text('Artwork 2'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays empty message when no artworks', (tester) async {
      final provider = ArtworksProvider(mockApiService);
      when(() => mockApiService.fetchArtworks(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(provider: provider));
      provider.fetchArtworks();
      await tester.pumpAndSettle();

      expect(find.text('No artworks found'), findsOneWidget);
    });

    testWidgets('shows search bar', (tester) async {
      final provider = ArtworksProvider(mockApiService);
      
      await tester.pumpWidget(createTestWidget(provider: provider));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search artworks...'), findsOneWidget);
    });
  });

  group('ArtworkDetailScreen', () {
    testWidgets('displays artwork metadata', (tester) async {
      final artwork = Artwork(
        id: 1,
        title: 'Test Artwork Title',
        artistTitle: 'Vincent van Gogh',
        dateDisplay: '1889',
        medium: 'Oil on canvas',
        dimensions: '73.7 × 92.1 cm',
        description: 'A famous painting',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ArtworkDetailScreen(artwork: artwork),
        ),
      );

      expect(find.text('Vincent van Gogh'), findsOneWidget);
      expect(find.text('1889'), findsOneWidget);
      expect(find.text('Oil on canvas'), findsOneWidget);
      expect(find.text('73.7 × 92.1 cm'), findsOneWidget);
      expect(find.text('A famous painting'), findsOneWidget);
    });

    testWidgets('displays InteractiveViewer for zoomable image', (tester) async {
      final artwork = Artwork(
        id: 1,
        title: 'Test Artwork',
        imageId: 'test-image-id',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ArtworkDetailScreen(artwork: artwork),
        ),
      );

      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('artist name is tappable', (tester) async {
      final artwork = Artwork(
        id: 1,
        title: 'Test Artwork',
        artistId: 123,
        artistTitle: 'Famous Artist',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ArtworkDetailScreen(artwork: artwork),
        ),
      );

      final artistLink = find.text('Famous Artist');
      expect(artistLink, findsOneWidget);

      await tester.tap(artistLink);
      await tester.pumpAndSettle();

      expect(find.text('Artist Detail Screen'), findsOneWidget);
    });

    testWidgets('shows placeholder when no image available', (tester) async {
      final artwork = Artwork(
        id: 1,
        title: 'No Image Artwork',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ArtworkDetailScreen(artwork: artwork),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });
  });
}
