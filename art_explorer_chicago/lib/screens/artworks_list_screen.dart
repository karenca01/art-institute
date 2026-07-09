import 'package:flutter/material.dart';

import '../widgets/placeholder_body.dart';

/// Displays a browsable list/grid of artworks.
///
/// This is currently a placeholder. Real data fetching, search, and
/// filtering will be implemented as part of the Artworks section work
/// (see project issue #5).
class ArtworksListScreen extends StatelessWidget {
  const ArtworksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artworks')),
      body: const PlaceholderBody(
        icon: Icons.image_outlined,
        message: 'Artworks will appear here.',
      ),
    );
  }
}
