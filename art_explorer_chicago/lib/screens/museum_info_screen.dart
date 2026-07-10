import 'package:flutter/material.dart';

import '../widgets/placeholder_body.dart';

/// Displays museum hours, location/map, and contact information.
///
/// This is currently a placeholder. Real data fetching and `url_launcher`
/// integration will be implemented as part of the Museum Info work
/// (see project issue #7).
class MuseumInfoScreen extends StatelessWidget {
  const MuseumInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Museum Info')),
      body: const PlaceholderBody(
        icon: Icons.info_outline,
        message: 'Museum hours, location, and contact info will appear here.',
      ),
    );
  }
}
