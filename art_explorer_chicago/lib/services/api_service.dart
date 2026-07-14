import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artwork.dart';
import '../models/artist.dart';
import '../models/exhibition.dart';
import '../models/museum_info.dart';
import 'api_exception.dart';

class ApiService {
  static const String _baseUrl = 'https://api.artic.edu/api/v1';
  final http.Client _httpClient;

  ApiService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<List<Artwork>> fetchArtworks({int page = 1, int limit = 10}) async {
    final response = await _get('/artworks?page=$page&limit=$limit');
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => Artwork.fromJson(json)).toList();
  }

  Future<Artwork> fetchArtwork(int id) async {
    final response = await _get('/artworks/$id');
    return Artwork.fromJson(response);
  }

  Future<List<Artist>> fetchArtists({int page = 1, int limit = 10}) async {
    final response = await _get('/artists?page=$page&limit=$limit');
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => Artist.fromJson(json)).toList();
  }

  Future<Artist> fetchArtist(int id) async {
    final response = await _get('/artists/$id');
    return Artist.fromJson(response);
  }

  Future<List<Exhibition>> fetchExhibitions({int page = 1, int limit = 10}) async {
    final response = await _get('/exhibitions?page=$page&limit=$limit');
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => Exhibition.fromJson(json)).toList();
  }

  Future<Exhibition> fetchExhibition(int id) async {
    final response = await _get('/exhibitions/$id');
    return Exhibition.fromJson(response);
  }

  Future<List<Artwork>> searchArtworks(String query, {int page = 1, int limit = 10}) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final response = await _get('/artworks/search?q=$encodedQuery&page=$page&limit=$limit');
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => Artwork.fromJson(json)).toList();
  }

  /// Fetches multiple artworks in a single request using the API's `ids`
  /// filter. Returns an empty list when [ids] is empty.
  Future<List<Artwork>> fetchArtworksByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final idParam = ids.join(',');
    final response = await _get('/artworks?ids=$idParam');
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => Artwork.fromJson(json)).toList();
  }

  Future<MuseumInfo> fetchMuseumInfo() async {
    final response = await _get('/museum-info');
    return MuseumInfo.fromJson(response);
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    
    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw NotFoundException('Resource not found: $endpoint');
      } else {
        throw ServerException(
          'Server error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
