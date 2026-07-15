import 'package:flutter_test/flutter_test.dart';
import 'package:art_explorer_chicago/models/artwork.dart';
import 'package:art_explorer_chicago/models/artist.dart';
import 'package:art_explorer_chicago/models/exhibition.dart';
import 'package:art_explorer_chicago/models/museum_info.dart';

void main() {
  group('Artwork', () {
    test('fromJson parses complete JSON correctly', () {
      final json = {
        'data': {
          'id': 123,
          'title': 'Starry Night',
          'artist_title': 'Vincent van Gogh',
          'artist_id': 456,
          'date_display': '1889',
          'date_start': 1889,
          'date_end': 1889,
          'medium_display': 'Oil on canvas',
          'dimensions': '73.7 × 92.1 cm',
          'description': 'A famous painting',
          'image_id': 'abc123',
          'credit_line': 'Gift of a donor',
          'is_public_domain': true,
          'department_title': 'Modern Art',
          'api_link': 'https://api.example.com/artworks/123',
        },
      };

      final artwork = Artwork.fromJson(json);

      expect(artwork.id, equals(123));
      expect(artwork.title, equals('Starry Night'));
      expect(artwork.artistTitle, equals('Vincent van Gogh'));
      expect(artwork.artistId, equals(456));
      expect(artwork.dateDisplay, equals('1889'));
      expect(artwork.dateStart, equals(1889));
      expect(artwork.dateEnd, equals(1889));
      expect(artwork.medium, equals('Oil on canvas'));
      expect(artwork.dimensions, equals('73.7 × 92.1 cm'));
      expect(artwork.description, equals('A famous painting'));
      expect(artwork.imageId, equals('abc123'));
      expect(artwork.creditLine, equals('Gift of a donor'));
      expect(artwork.isPublicDomain, isTrue);
      expect(artwork.departmentTitle, equals('Modern Art'));
      expect(artwork.apiLink, equals('https://api.example.com/artworks/123'));
    });

    test('fromJson handles missing/null fields', () {
      final json = {
        'data': {
          'id': 1,
          'title': 'Untitled',
        },
      };

      final artwork = Artwork.fromJson(json);

      expect(artwork.id, equals(1));
      expect(artwork.title, equals('Untitled'));
      expect(artwork.artistTitle, isNull);
      expect(artwork.artistId, isNull);
      expect(artwork.imageId, isNull);
    });

    test('toJson creates correct JSON structure', () {
      final artwork = Artwork(
        id: 123,
        title: 'Starry Night',
        artistTitle: 'Vincent van Gogh',
        imageId: 'abc123',
      );

      final json = artwork.toJson();

      expect(json['id'], equals(123));
      expect(json['title'], equals('Starry Night'));
      expect(json['artist_title'], equals('Vincent van Gogh'));
      expect(json['image_id'], equals('abc123'));
    });
  });

  group('Artist', () {
    test('fromJson parses complete JSON correctly', () {
      final json = {
        'data': {
          'id': 456,
          'title': 'Vincent van Gogh',
          'birth_date': 1853,
          'death_date': 1890,
          'nationality': 'Dutch',
          'biography': 'A famous painter',
          'api_link': 'https://api.example.com/artists/456',
        },
      };

      final artist = Artist.fromJson(json);

      expect(artist.id, equals(456));
      expect(artist.title, equals('Vincent van Gogh'));
      expect(artist.birthDate, equals(1853));
      expect(artist.deathDate, equals(1890));
      expect(artist.nationality, equals('Dutch'));
      expect(artist.biography, equals('A famous painter'));
    });

    test('fromJson handles missing fields', () {
      final json = {
        'data': {
          'id': 1,
          'title': 'Unknown Artist',
        },
      };

      final artist = Artist.fromJson(json);

      expect(artist.id, equals(1));
      expect(artist.title, equals('Unknown Artist'));
      expect(artist.birthDate, isNull);
      expect(artist.nationality, isNull);
    });

    test('toJson creates correct JSON structure', () {
      final artist = Artist(
        id: 456,
        title: 'Vincent van Gogh',
        birthDate: 1853,
        nationality: 'Dutch',
      );

      final json = artist.toJson();

      expect(json['id'], equals(456));
      expect(json['title'], equals('Vincent van Gogh'));
      expect(json['birth_date'], equals(1853));
      expect(json['nationality'], equals('Dutch'));
    });
  });

  group('Exhibition', () {
    test('fromJson parses complete JSON correctly', () {
      final json = {
        'data': {
          'id': 789,
          'title': 'Modern Masters',
          'description': 'A collection of modern art',
          'start_date': '2026-01-01',
          'end_date': '2026-06-30',
          'is_current': true,
          'artwork_ids': [1, 2, 3],
          'api_link': 'https://api.example.com/exhibitions/789',
        },
      };

      final exhibition = Exhibition.fromJson(json);

      expect(exhibition.id, equals(789));
      expect(exhibition.title, equals('Modern Masters'));
      expect(exhibition.description, equals('A collection of modern art'));
      expect(exhibition.startDate, equals('2026-01-01'));
      expect(exhibition.endDate, equals('2026-06-30'));
      expect(exhibition.isCurrent, isTrue);
      expect(exhibition.artworkIds, equals([1, 2, 3]));
    });

    test('fromJson handles empty artwork_ids', () {
      final json = {
        'data': {
          'id': 1,
          'title': 'Exhibition',
          'artwork_ids': [],
        },
      };

      final exhibition = Exhibition.fromJson(json);

      expect(exhibition.artworkIds, isEmpty);
    });

    test('toJson creates correct JSON structure', () {
      final exhibition = Exhibition(
        id: 789,
        title: 'Modern Masters',
        artworkIds: [1, 2, 3],
      );

      final json = exhibition.toJson();

      expect(json['id'], equals(789));
      expect(json['title'], equals('Modern Masters'));
      expect(json['artwork_ids'], equals([1, 2, 3]));
    });
  });

  group('MuseumInfo', () {
    test('fromJson parses complete JSON correctly', () {
      final json = {
        'data': {
          'name': 'Art Institute of Chicago',
          'address': '111 S Michigan Ave, Chicago, IL 60603',
          'hours': {
            'Monday': '10:30 AM - 5:00 PM',
            'Tuesday': 'Closed',
          },
          'phone': '+1 (312) 443-3600',
          'email': 'info@artic.edu',
          'website': 'https://www.artic.edu',
        },
      };

      final museumInfo = MuseumInfo.fromJson(json);

      expect(museumInfo.name, equals('Art Institute of Chicago'));
      expect(museumInfo.address, equals('111 S Michigan Ave, Chicago, IL 60603'));
      expect(museumInfo.hours, isNotNull);
      expect(museumInfo.hours!['Monday'], equals('10:30 AM - 5:00 PM'));
      expect(museumInfo.hours!['Tuesday'], equals('Closed'));
      expect(museumInfo.phone, equals('+1 (312) 443-3600'));
      expect(museumInfo.email, equals('info@artic.edu'));
      expect(museumInfo.website, equals('https://www.artic.edu'));
    });

    test('fromJson handles missing hours', () {
      final json = {
        'data': {
          'name': 'Museum',
          'address': '123 Main St',
        },
      };

      final museumInfo = MuseumInfo.fromJson(json);

      expect(museumInfo.name, equals('Museum'));
      expect(museumInfo.address, equals('123 Main St'));
      expect(museumInfo.hours, isNull);
      // Address/phone/website fall back to the museum's known public details
      // when the API does not supply them.
      expect(museumInfo.phone, equals(MuseumInfo.defaultPhone));
    });

    test('fromJson uses default name if missing', () {
      final json = <String, dynamic>{};

      final museumInfo = MuseumInfo.fromJson(json);

      expect(museumInfo.name, equals('Art Institute of Chicago'));
    });

    test('toJson creates correct JSON structure', () {
      final museumInfo = MuseumInfo(
        name: 'Art Institute of Chicago',
        address: '111 S Michigan Ave',
        hours: {'Monday': '10:30 AM - 5:00 PM'},
      );

      final json = museumInfo.toJson();

      expect(json['name'], equals('Art Institute of Chicago'));
      expect(json['address'], equals('111 S Michigan Ave'));
      expect(json['hours'], isNotNull);
    });
  });
}
