import 'package:flutter/material.dart';

import 'artist_list_screen.dart';
import 'artworks_list_screen.dart';
import 'exhibitions_list_screen.dart';
import 'museum_info_screen.dart';

/// The app's main navigation shell.
///
/// Hosts the four top-level sections (Artworks, Exhibitions, Museum Info,
/// Artists) behind a [BottomNavigationBar], preserving each tab's state via
/// an [IndexedStack].
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ArtworksListScreen(),
    ExhibitionsListScreen(),
    MuseumInfoScreen(),
    ArtistListScreen(),
  ];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.image_outlined),
      selectedIcon: Icon(Icons.image),
      label: 'Artworks',
    ),
    NavigationDestination(
      icon: Icon(Icons.event_outlined),
      selectedIcon: Icon(Icons.event),
      label: 'Exhibitions',
    ),
    NavigationDestination(
      icon: Icon(Icons.info_outline),
      selectedIcon: Icon(Icons.info),
      label: 'Museum Info',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Artists',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
      ),
    );
  }
}
