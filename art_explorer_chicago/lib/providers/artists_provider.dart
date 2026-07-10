import 'package:flutter/foundation.dart';
import '../models/artist.dart';
import '../services/api_service.dart';
import 'artworks_provider.dart';

class ArtistsProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  ProviderState _state = ProviderState.initial;
  List<Artist> _artists = [];
  Artist? _selectedArtist;
  String? _errorMessage;
  
  ArtistsProvider(this._apiService);
  
  ProviderState get state => _state;
  List<Artist> get artists => _artists;
  Artist? get selectedArtist => _selectedArtist;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchArtists({int page = 1, int limit = 20}) async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _artists = await _apiService.fetchArtists(page: page, limit: limit);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<void> fetchArtist(int id) async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _selectedArtist = await _apiService.fetchArtist(id);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  void clearSelectedArtist() {
    _selectedArtist = null;
    notifyListeners();
  }
}
