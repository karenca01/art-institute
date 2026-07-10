import 'package:flutter/foundation.dart';
import '../models/exhibition.dart';
import '../services/api_service.dart';
import 'artworks_provider.dart';

class ExhibitionsProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  ProviderState _state = ProviderState.initial;
  List<Exhibition> _exhibitions = [];
  Exhibition? _selectedExhibition;
  String? _errorMessage;
  
  ExhibitionsProvider(this._apiService);
  
  ProviderState get state => _state;
  List<Exhibition> get exhibitions => _exhibitions;
  Exhibition? get selectedExhibition => _selectedExhibition;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchExhibitions({int page = 1, int limit = 20}) async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _exhibitions = await _apiService.fetchExhibitions(page: page, limit: limit);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<void> fetchExhibition(int id) async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _selectedExhibition = await _apiService.fetchExhibition(id);
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  void clearSelectedExhibition() {
    _selectedExhibition = null;
    notifyListeners();
  }
}
