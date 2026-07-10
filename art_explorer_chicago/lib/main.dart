import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_shell.dart';
import 'services/api_service.dart';
import 'providers/artworks_provider.dart';
import 'providers/exhibitions_provider.dart';
import 'providers/artists_provider.dart';
import 'providers/museum_info_provider.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget for the Art Explorer Chicago app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArtworksProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ExhibitionsProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ArtistsProvider(apiService)),
        ChangeNotifierProvider(create: (_) => MuseumInfoProvider(apiService)),
      ],
      child: MaterialApp(
        title: 'Art Explorer Chicago',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeShell(),
      ),
    );
  }
}
