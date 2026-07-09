import 'package:flutter/material.dart';

import '../widgets/placeholder_body.dart';

/// Displays current and upcoming exhibitions.
///
/// This is currently a placeholder. Real data fetching will be implemented
/// as part of the Exhibitions section work (see project issue #6).
class ExhibitionsListScreen extends StatelessWidget {
  const ExhibitionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exhibitions')),
      body: const PlaceholderBody(
        icon: Icons.event_outlined,
        message: 'Exhibitions will appear here.',
      ),
    );
  }
}
