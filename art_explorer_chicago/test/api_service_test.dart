import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_mock;
import 'package:art_explorer_chicago/services/api_service.dart';
import 'package:art_explorer_chicago/services/api_exception.dart';
import 'package:art_explorer_chicago/utils/iiif_url_builder.dart';

void main() {
  group('ApiService', () {
    test('fetchArtworks returns list of artworks on success', () async {
      final mockResponse = {
        'data': [
          {'id': 1, 'title': 'Artwork 1'},
          {'id': 2, 'title': 'Artwork 2'},
        ],
      };

      final mockClient = http_mock.MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final apiService = ApiService(httpClient: mockClient);
      final artworks = await apiService.fetchArtworks();

      expect(artworks.length, equals(2));
      expect(artworks[0].id, equals(1));
      expect(artworks[1].title, equals('Artwork 2'));

      apiService.dispose();
    });

    test('fetchArtwork returns artwork detail on success', () async {
      final mockResponse = {
        'data': {'id': 123, 'title': 'Starry Night'},
      };

      final mockClient = http_mock.MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final apiService = ApiService(httpClient: mockClient);
      final artwork = await apiService.fetchArtwork(123);

      expect(artwork.id, equals(123));
      expect(artwork.title, equals('Starry Night'));

      apiService.dispose();
    });

    test('fetchArtwork throws NotFoundException on 404', () async {
      final mockClient = http_mock.MockClient((request) async {
        return http.Response('Not found', 404);
      });

      final apiService = ApiService(httpClient: mockClient);

      expect(
        () => apiService.fetchArtwork(999),
        throwsA(isA<NotFoundException>()),
      );

      apiService.dispose();
    });

    test('fetchArtworks throws ServerException on 500', () async {
      final mockClient = http_mock.MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final apiService = ApiService(httpClient: mockClient);

      expect(
        () => apiService.fetchArtworks(),
        throwsA(isA<ServerException>()),
      );

      apiService.dispose();
    });

    test('fetchArtists returns list of artists on success', () async {
      final mockResponse = {
        'data': [
          {'id': 1, 'title': 'Artist 1'},
          {'id': 2, 'title': 'Artist 2'},
        ],
      };

      final mockClient = http_mock.MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final apiService = ApiService(httpClient: mockClient);
      final artists = await apiService.fetchArtists();

      expect(artists.length, equals(2));
      expect(artists[0].id, equals(1));

      apiService.dispose();
    });

    test('fetchExhibitions returns list of exhibitions on success', () async {
      final mockResponse = {
        'data': [
          {'id': 1, 'title': 'Exhibition 1'},
          {'id': 2, 'title': 'Exhibition 2'},
        ],
      };

      final mockClient = http_mock.MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final apiService = ApiService(httpClient: mockClient);
      final exhibitions = await apiService.fetchExhibitions();

      expect(exhibitions.length, equals(2));

      apiService.dispose();
    });

    test('searchArtworks returns search results', () async {
      final mockResponse = {
        'data': [
          {'id': 1, 'title': 'Starry Night'},
        ],
      };

      final mockClient = http_mock.MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final apiService = ApiService(httpClient: mockClient);
      final results = await apiService.searchArtworks('starry');

      expect(results.length, equals(1));
      expect(results[0].title, equals('Starry Night'));

      apiService.dispose();
    });

    test('fetchMuseumInfo returns museum information', () async {
      // The API now serves hours from the `/hours` endpoint, whose `data`
      // is a list of hour records with per-day ISO-8601 duration fields.
      final mockResponse = {
        'data': [
          {
            'monday_is_closed': false,
            'monday_public_open': 'PT11H00M',
            'monday_public_close': 'PT17H00M',
            'tuesday_is_closed': true,
          },
        ],
      };

      final mockClient = http_mock.MockClient((request) async {
        return http.Response(json.encode(mockResponse), 200);
      });

      final apiService = ApiService(httpClient: mockClient);
      final museumInfo = await apiService.fetchMuseumInfo();

      expect(museumInfo.name, equals('Art Institute of Chicago'));
      expect(museumInfo.hours, isNotNull);
      expect(museumInfo.hours!['Monday'], equals('11 AM – 5 PM'));
      expect(museumInfo.hours!['Tuesday'], equals('Closed'));

      apiService.dispose();
    });
  });

  group('IiifUrlBuilder', () {
    test('buildImageUrl constructs correct URL with defaults', () {
      final url = IiifUrlBuilder.buildImageUrl('abc123');
      expect(url, equals('https://www.artic.edu/iiif/2/abc123/full/843,/0/default.jpg'));
    });

    test('buildImageUrl constructs correct URL with custom parameters', () {
      final url = IiifUrlBuilder.buildImageUrl(
        'abc123',
        width: 500,
        height: 600,
        region: 'square',
        rotation: '90',
        quality: 'color',
        format: 'png',
      );
      expect(url, equals('https://www.artic.edu/iiif/2/abc123/square/500,600/90/color.png'));
    });

    test('buildThumbnailUrl constructs correct thumbnail URL', () {
      final url = IiifUrlBuilder.buildThumbnailUrl('abc123');
      expect(url, equals('https://www.artic.edu/iiif/2/abc123/full/400,/0/default.jpg'));
    });

    test('buildHighResUrl constructs correct high-res URL', () {
      final url = IiifUrlBuilder.buildHighResUrl('abc123');
      expect(url, equals('https://www.artic.edu/iiif/2/abc123/full/1686,/0/default.jpg'));
    });
  });
}
