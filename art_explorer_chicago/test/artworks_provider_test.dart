import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:art_explorer_chicago/providers/artworks_provider.dart';
import 'package:art_explorer_chicago/providers/artworks_provider.dart' show ProviderState;
import 'package:art_explorer_chicago/models/artwork.dart';
import 'package:art_explorer_chicago/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('ArtworksProvider', () {
    late MockApiService mockApiService;
    late ArtworksProvider provider;

    setUp(() {
      mockApiService = MockApiService();
      provider = ArtworksProvider(mockApiService);
    });

    test('initial state is correct', () {
      expect(provider.state, equals(ProviderState.initial));
      expect(provider.artworks, isEmpty);
      expect(provider.selectedArtwork, isNull);
      expect(provider.errorMessage, isNull);
    });

    test('fetchArtworks transitions from loading to loaded on success', () async {
      final mockArtworks = [
        Artwork(id: 1, title: 'Artwork 1'),
        Artwork(id: 2, title: 'Artwork 2'),
      ];
      
      when(() => mockApiService.fetchArtworks(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => mockArtworks);

      final states = <ProviderState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.fetchArtworks();

      expect(states, equals([ProviderState.loading, ProviderState.loaded]));
      expect(provider.artworks.length, equals(2));
      expect(provider.artworks[0].title, equals('Artwork 1'));
      expect(provider.errorMessage, isNull);
      
      verify(() => mockApiService.fetchArtworks(page: 1, limit: 20)).called(1);
    });

    test('fetchArtworks transitions from loading to error on failure', () async {
      when(() => mockApiService.fetchArtworks(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenThrow(Exception('Network error'));

      final states = <ProviderState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.fetchArtworks();

      expect(states, equals([ProviderState.loading, ProviderState.error]));
      expect(provider.artworks, isEmpty);
      expect(provider.errorMessage, isNotNull);
      expect(provider.errorMessage, contains('Network error'));
    });

    test('fetchArtwork sets selectedArtwork on success', () async {
      final mockArtwork = Artwork(id: 123, title: 'Starry Night');
      
      when(() => mockApiService.fetchArtwork(123))
          .thenAnswer((_) async => mockArtwork);

      await provider.fetchArtwork(123);

      expect(provider.state, equals(ProviderState.loaded));
      expect(provider.selectedArtwork, isNotNull);
      expect(provider.selectedArtwork!.id, equals(123));
      
      verify(() => mockApiService.fetchArtwork(123)).called(1);
    });

    test('searchArtworks calls API with query', () async {
      final mockArtworks = [
        Artwork(id: 1, title: 'Starry Night'),
      ];
      
      when(() => mockApiService.searchArtworks(any(), page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => mockArtworks);

      await provider.searchArtworks('starry');

      expect(provider.state, equals(ProviderState.loaded));
      expect(provider.searchQuery, equals('starry'));
      expect(provider.artworks.length, equals(1));
      
      verify(() => mockApiService.searchArtworks('starry', page: 1, limit: 20)).called(1);
    });

    test('searchArtworks with empty query calls fetchArtworks', () async {
      final mockArtworks = [
        Artwork(id: 1, title: 'Artwork 1'),
      ];
      
      when(() => mockApiService.fetchArtworks(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => mockArtworks);

      await provider.searchArtworks('');

      expect(provider.searchQuery, isEmpty);
      verify(() => mockApiService.fetchArtworks(page: 1, limit: 20)).called(1);
    });

    test('clearSearch resets state', () async {
      final mockArtworks = [Artwork(id: 1, title: 'Test')];
      when(() => mockApiService.searchArtworks(any(), page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => mockArtworks);

      await provider.searchArtworks('test');
      expect(provider.searchQuery, equals('test'));

      provider.clearSearch();

      expect(provider.searchQuery, isEmpty);
      expect(provider.artworks, isEmpty);
      expect(provider.state, equals(ProviderState.initial));
    });

    test('clearSelectedArtwork removes selected artwork', () async {
      final mockArtwork = Artwork(id: 123, title: 'Test');
      when(() => mockApiService.fetchArtwork(123))
          .thenAnswer((_) async => mockArtwork);

      await provider.fetchArtwork(123);
      expect(provider.selectedArtwork, isNotNull);

      provider.clearSelectedArtwork();

      expect(provider.selectedArtwork, isNull);
    });
  });
}
