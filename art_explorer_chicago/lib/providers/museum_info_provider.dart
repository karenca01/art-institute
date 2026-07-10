import 'package:flutter/foundation.dart';
import '../models/museum_info.dart';
import '../services/api_service.dart';
import 'artworks_provider.dart';

class MuseumInfoProvider extends ChangeNotifier {
  final ApiService _apiService;
  
  ProviderState _state = ProviderState.initial;
  MuseumInfo? _museumInfo;
  String? _errorMessage;
  
  MuseumInfoProvider(this._apiService);
  
  ProviderState get state => _state;
  MuseumInfo? get museumInfo => _museumInfo;
  String? get errorMessage => _errorMessage;
  
  Future<void> fetchMuseumInfo() async {
    _state = ProviderState.loading;
    notifyListeners();
    
    try {
      _museumInfo = await _apiService.fetchMuseumInfo();
      _state = ProviderState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = ProviderState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
}
