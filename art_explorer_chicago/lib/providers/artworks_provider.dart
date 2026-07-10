import 'package:flutter/foundation.dart';
import '../models/artwork.dart';
import '../services/api_service.dart';

enum ProviderState {
  initial,
  loading,
  loaded,
  error,
}

class ArtworksProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  ProviderState _state = ProviderState.initial;
  List<Artwork> _artworks = [];
  Artwork? _selectedArtwork;
  String? _errorMessage;
  String _searchQuery = '';
  
  ArtworksProvider(this._apiService);
  
  ProviderState get state => _state;
  List<Artwork> get artworks => _artworks;
  Artwork? get selectedArtwork => _selectedArtwork;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  
  Future<void> fetchArtworks({int page = 1, int limit = 20}) async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _artworks = await _apiService.fetchArtworks(page: page, limit: limit);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<void> fetchArtwork(int id) async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _selectedArtwork = await _apiService.fetchArtwork(id);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<void> searchArtworks(String query, {int page = 1, int limit = 20}) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      await fetchArtworks(page: page, limit: limit);
      return;
    }
    
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _artworks = await _apiService.searchArtworks(query, page: page, limit: limit);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  void clearSearch() {
    _searchQuery = '';
    _artworks = [];
    _state = ProviderState.initial;
    notifyListeners();
  }
  
  void clearSelectedArtwork() {
    _selectedArtwork = null;
    notifyListeners();
  }
}
