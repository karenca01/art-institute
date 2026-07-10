import 'package:flutter/material.dart';

import '../widgets/placeholder_body.dart';

/// Displays a browsable list of artists.
///
/// This is currently a placeholder. Real data fetching will be implemented
/// as part of the Artists section work (see project issue #8).
class ArtistListScreen extends StatelessWidget {
  const ArtistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artists')),
      body: const PlaceholderBody(
        icon: Icons.person_outline,
        message: 'Artists will appear here.',
      ),
    );
  }
}
